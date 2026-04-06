import 'dart:io';
import 'package:dotted_border/dotted_border.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppFileUploadPicker extends StatefulWidget {
  final UploadPickerValue? initialValue;
  final ValueChanged<UploadPickerValue?>? onChanged;

  /// optional reactive_forms support
  final String? formControlName;
  final FormControl<UploadPickerValue?>? formControl;
  final Map<String, String Function(Object)>? validationMessages;

  final double height;
  final double radius;
  final String title;
  final String subtitle;
  final bool enabled;

  const AppFileUploadPicker({
    super.key,
    this.initialValue,
    this.onChanged,
    this.formControlName,
    this.formControl,
    this.validationMessages,
    this.height = 110,
    this.radius = 16,
    this.title = 'Tap to upload',
    this.subtitle = 'Accepts pdf, jpg, or png (Max 10MB)',
    this.enabled = true,
  }) : assert(
         formControlName == null || formControl == null,
         'Provide either formControlName or formControl, not both.',
       );

  bool get isReactive => formControlName != null || formControl != null;

  @override
  State<AppFileUploadPicker> createState() => _AppFileUploadPickerState();
}

class _AppFileUploadPickerState extends State<AppFileUploadPicker> {
  UploadPickerValue? _value;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  void didUpdateWidget(covariant AppFileUploadPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialValue != widget.initialValue) {
      _value = widget.initialValue;
    }
  }

  Future<UploadPickerValue?> _pickFileValue() async {
    if (!widget.enabled) return null;

    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg', 'webp'],
      allowMultiple: false,
      withData: false,
    );

    if (result == null || result.files.isEmpty) return null;

    final picked = result.files.first;
    final path = picked.path;
    final name = picked.name;

    if (path == null) return null;

    final type = UploadPickerValue.detectTypeFromName(name);

    return UploadPickerValue(
      path: path,
      name: name,
      file: File(path),
      type: type,
    );
  }

  bool _isSameValue(UploadPickerValue? a, UploadPickerValue? b) {
    return a?.path == b?.path &&
        a?.url == b?.url &&
        a?.name == b?.name &&
        a?.type == b?.type;
  }

  Future<void> _pickFileNonReactive() async {
    final newValue = await _pickFileValue();
    if (newValue == null) return;

    setState(() {
      _value = newValue;
    });

    widget.onChanged?.call(newValue);
  }

  void _removeFileNonReactive() {
    setState(() {
      _value = null;
    });
    widget.onChanged?.call(null);
  }

  bool _hasLocalImage(UploadPickerValue? value) =>
      value?.file != null && value?.type == UploadFileType.image;

  bool _hasNetworkImage(UploadPickerValue? value) =>
      (value?.url?.isNotEmpty == true) &&
      value?.type == UploadPickerValue.detectTypeFromName(value?.url);

  @override
  Widget build(BuildContext context) {
    if (widget.isReactive) {
      return ReactiveFormField<UploadPickerValue?, UploadPickerValue?>(
        formControlName: widget.formControlName,
        formControl: widget.formControl,
        validationMessages: widget.validationMessages,
        builder: (field) {
          final controlValue = field.value;

          if (!_isSameValue(controlValue, _value)) {
            _value = controlValue ?? widget.initialValue;
          }

          if (controlValue == null &&
              widget.initialValue != null &&
              !_isSameValue(controlValue, widget.initialValue)) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (!mounted) return;
              field.didChange(widget.initialValue);
            });
          }

          final hasError = field.control.invalid && field.control.touched;

          return _buildPickerUi(
            value: field.value ?? _value,
            errorText: hasError ? field.errorText : null,
            onTap: () async {
              final newValue = await _pickFileValue();
              if (newValue == null) return;

              field.didChange(newValue);
              field.control.markAsTouched();
              setState(() {
                _value = newValue;
              });
              widget.onChanged?.call(newValue);
            },
            onRemove: () {
              field.didChange(null);
              field.control.markAsTouched();
              setState(() {
                _value = null;
              });
              widget.onChanged?.call(null);
            },
          );
        },
      );
    }

    return _buildPickerUi(
      value: _value,
      errorText: null,
      onTap: _pickFileNonReactive,
      onRemove: _removeFileNonReactive,
    );
  }

  Widget _buildPickerUi({
    required UploadPickerValue? value,
    required String? errorText,
    required VoidCallback onTap,
    required VoidCallback onRemove,
  }) {
    final radius = BorderRadius.circular(widget.radius);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            InkWell(
              onTap: onTap,
              borderRadius: radius,
              child: DottedBorder(
                options: RectDottedBorderOptions(
                  color: errorText != null
                      ? Colors.red
                      : const Color(0xFFE0E0E0),
                  strokeWidth: 2,
                  dashPattern: const [8, 4],
                ),
                child: Container(
                  width: double.infinity,
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8F8F8),
                    borderRadius: radius,
                  ),
                  child: _buildContent(value),
                ),
              ),
            ),
            if (value?.hasValue == true)
              Positioned(
                top: -8,
                right: -8,
                child: InkWell(
                  onTap: onRemove,
                  borderRadius: BorderRadius.circular(100),
                  child: Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFFE0E0E0)),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x14000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.close,
                      size: 16,
                      color: Colors.redAccent,
                    ),
                  ),
                ),
              ),
          ],
        ),
        if (errorText != null) ...[
          const SizedBox(height: 6),
          Text(
            errorText,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.red,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildContent(UploadPickerValue? value) {
    if (value?.hasValue != true) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.title, style: TextStyleManager.font16SemiBold(context)),
          SizedBox(height: 6.h),
          Text(
            widget.subtitle,
            style: TextStyleManager.font14GrayMedium(context),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    if (_hasLocalImage(value)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: Image.file(
          value!.file!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }

    if (_hasNetworkImage(value)) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(widget.radius),
        child: Image.network(
          value!.url!,
          width: double.infinity,
          height: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFileInfo(value),
        ),
      );
    }

    return _buildFileInfo(value);
  }

  Widget _buildFileInfo(UploadPickerValue? value) {
    final isPdf = value?.type == UploadFileType.pdf;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: isPdf ? const Color(0xFFFFF1F0) : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isPdf ? Icons.picture_as_pdf_rounded : Icons.image_outlined,
              color: isPdf ? Colors.red : Colors.blue,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              value?.name ??
                  value?.path?.split(Platform.pathSeparator).last ??
                  value?.url?.split('/').last ??
                  'Selected file',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF333333),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

enum UploadFileType { image, pdf, unknown }

class UploadPickerValue {
  final String? path;
  final String? name;
  final String? url;
  final UploadFileType type;
  final File? file;

  const UploadPickerValue({
    this.path,
    this.name,
    this.url,
    this.type = UploadFileType.unknown,
    this.file,
  });

  bool get hasValue =>
      (file != null) ||
      (path != null && path!.isNotEmpty) ||
      (url != null && url!.isNotEmpty);

  UploadPickerValue copyWith({
    String? path,
    String? name,
    String? url,
    UploadFileType? type,
    File? file,
  }) {
    return UploadPickerValue(
      path: path ?? this.path,
      name: name ?? this.name,
      url: url ?? this.url,
      type: type ?? this.type,
      file: file ?? this.file,
    );
  }

  static UploadFileType detectTypeFromName(String? nameOrPath) {
    final value = (nameOrPath ?? '').toLowerCase();
    if (value.endsWith('.pdf')) return UploadFileType.pdf;
    if (value.endsWith('.png') ||
        value.endsWith('.jpg') ||
        value.endsWith('.jpeg') ||
        value.endsWith('.webp')) {
      return UploadFileType.image;
    }
    return UploadFileType.unknown;
  }
}
