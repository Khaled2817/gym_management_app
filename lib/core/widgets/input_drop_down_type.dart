import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/shard_models.dart/dd_model.dart';
import 'package:reactive_forms/reactive_forms.dart';

typedef ReactiveDropDownButtonInputTypeS =
    ReactiveDropDownButtonInputType<String>;

class ReactiveDropDownButtonInputType<T> extends StatefulWidget {
  final String hintText;

  /// ✅ reactive
  final String? formControlName;
  final FormControl<T>? formControl;

  /// ✅ typed items
  final List<DDModel<T>>? items;

  /// ✅ async typed items
  final Future<List<DDModel<T>>> Function()? getData;

  /// ✅ optional mapping
  final T Function(DDModel<T> item)? valueBuilder;

  final Color? borderColor;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final TextStyle? hintTextStyle;
  final TextStyle? textStyle;
  final TextStyle? errorTextStyle;

  final String? role;
  final bool isDarkMode;

  /// ✅ optional custom validation messages
  final Map<String, String Function(Object)>? validationMessages;

  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Color? backgroundColor;
  final Color? focusedBorderColor;
  final Color? iconColor;

  const ReactiveDropDownButtonInputType({
    super.key,
    this.role,
    required this.hintText,
    this.formControlName,
    this.formControl,
    this.items,
    this.getData,
    this.valueBuilder,
    this.borderColor,
    this.borderRadius,
    this.padding,
    this.hintTextStyle,
    this.textStyle,
    this.errorTextStyle,
    this.isDarkMode = false,
    this.validationMessages,
    this.prefixIcon,
    this.suffixIcon,
    this.backgroundColor,
    this.focusedBorderColor,
    this.iconColor,
  }) : assert(
         formControlName != null || formControl != null,
         'Either formControlName or formControl must be provided.',
       );

  @override
  State<ReactiveDropDownButtonInputType<T>> createState() =>
      _ReactiveDropDownButtonInputTypeState<T>();
}

class _ReactiveDropDownButtonInputTypeState<T>
    extends State<ReactiveDropDownButtonInputType<T>> {
  List<DDModel<T>> _cachedItems = [];
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  @override
  void didUpdateWidget(covariant ReactiveDropDownButtonInputType<T> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.items != null && widget.items != oldWidget.items) {
      _cachedItems = widget.items!;
      _errorMessage = null;
    }

    if (widget.getData != oldWidget.getData) {
      _loadItems();
    }
  }

  Future<void> _loadItems() async {
    if (widget.items != null) {
      setState(() {
        _cachedItems = widget.items!;
        _errorMessage = null;
      });
      return;
    }

    if (widget.getData == null) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final items = await widget.getData!();
      if (!mounted) return;
      setState(() {
        _cachedItems = items;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Failed to load items';
      });
    } finally {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  T _resolveValue(DDModel<T> item) {
    return widget.valueBuilder?.call(item) ?? item.id;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = widget.isDarkMode;

    final Color borderColor =
        widget.borderColor ?? (isDark ? Colors.grey[700]! : Colors.grey[300]!);

    final Color backgroundColor =
        widget.backgroundColor ??
        (isDark ? const Color(0xFF1E1E1E) : Colors.white);

    final Color iconColor =
        widget.iconColor ?? (isDark ? Colors.white70 : Colors.black54);

    final Color focusedBorderColor =
        widget.focusedBorderColor ?? (isDark ? Colors.blueAccent : Colors.blue);

    final BorderRadius borderRadius =
        widget.borderRadius ?? BorderRadius.circular(12.r);

    final EdgeInsetsGeometry padding =
        widget.padding ??
        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h);

    if (_errorMessage != null) {
      return _buildErrorWidget(
        errorMessage: _errorMessage!,
        borderRadius: borderRadius,
      );
    }

    return ReactiveFormField<T, T>(
      formControlName: widget.formControlName,
      formControl: widget.formControl,
      validationMessages: widget.validationMessages,
      builder: (field) {
        final hasError = field.errorText != null && field.control.touched;

        return DropdownButtonFormField2<T>(
          key: ValueKey<T?>(field.value),
          value: field.value,
          isExpanded: true,
          validator: (_) => hasError ? field.errorText : null,
          onChanged: (value) {
            field.didChange(value);
            field.control.markAsTouched();
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 1.2),
              borderRadius: borderRadius,
            ),
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor),
              borderRadius: borderRadius,
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: focusedBorderColor, width: 1.3),
              borderRadius: borderRadius,
            ),
            errorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.2),
              borderRadius: borderRadius,
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderSide: const BorderSide(color: Colors.red, width: 1.3),
              borderRadius: borderRadius,
            ),
            filled: true,
            fillColor: backgroundColor,
            contentPadding: padding,
            errorText: hasError ? field.errorText : null,
            errorStyle:
                widget.errorTextStyle ??
                TextStyle(color: Colors.red[700], fontSize: 12.sp),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.suffixIcon,
          ),
          hint: Text(
            widget.hintText,
            style:
                widget.hintTextStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: isDark ? Colors.white54 : Colors.grey,
                ),
          ),
          items: _cachedItems.map((item) {
            final val = _resolveValue(item);
            return DropdownMenuItem<T>(
              value: val,
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style:
                    widget.textStyle ??
                    TextStyle(
                      fontSize: 13.sp,
                      color: isDark ? Colors.white : Colors.black87,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            );
          }).toList(),
          iconStyleData: IconStyleData(
            icon: _isLoading
                ? SizedBox(
                    width: 20.w,
                    height: 20.w,
                    child: const CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: iconColor,
                    size: 22.sp,
                  ),
          ),
          dropdownStyleData: DropdownStyleData(
            padding: EdgeInsets.symmetric(vertical: 6.h),
            decoration: BoxDecoration(
              borderRadius: borderRadius,
              color: backgroundColor,
              boxShadow: [
                if (!isDark)
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 8.r,
                    offset: Offset(0, 4.h),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildErrorWidget({
    required String errorMessage,
    required BorderRadius borderRadius,
  }) {
    return InputDecorator(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.red),
          borderRadius: borderRadius,
        ),
        filled: true,
        fillColor: Colors.red.withOpacity(0.05),
        contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
        errorText: errorMessage,
        errorStyle:
            widget.errorTextStyle ??
            TextStyle(color: Colors.red[700], fontSize: 12.sp),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              widget.hintText,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:
                  widget.hintTextStyle ??
                  TextStyle(fontSize: 14.sp, color: Colors.grey),
            ),
          ),
          const Icon(Icons.error_outline, color: Colors.red),
        ],
      ),
    );
  }
}
