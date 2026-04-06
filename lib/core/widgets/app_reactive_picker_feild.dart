import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactiveDatePickerField extends StatefulWidget {
  final String formControlName;

  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;

  final String hintText;
  final String? lableText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final Color? enabledBorderColor;

  final Map<String, String Function(Object)>? validationMessages;

  final DateTime? firstDate;
  final DateTime? lastDate;
  final DateTime? initialDate;
  final DateTime? initialValue;
  final String dateFormat;
  final Locale? locale;

  final ValueChanged<DateTime?>? onSelected;

  const AppReactiveDatePickerField({
    super.key,
    required this.formControlName,
    required this.hintText,
    this.contentPadding,
    this.focusedBorder,
    this.enabledBorder,
    this.inputTextStyle,
    this.labelStyle,
    this.hintStyle,
    this.lableText,
    this.suffixIcon,
    this.prefixIcon,
    this.backgroundColor,
    this.enabledBorderColor,
    this.validationMessages,
    this.firstDate,
    this.lastDate,
    this.initialDate,
    this.initialValue,
    this.dateFormat = 'yyyy-MM-dd',
    this.locale,
    this.onSelected,
  });

  @override
  State<AppReactiveDatePickerField> createState() =>
      _AppReactiveDatePickerFieldState();
}

class _AppReactiveDatePickerFieldState
    extends State<AppReactiveDatePickerField> {
  bool _didSetInitialValue = false;

  @override
  Widget build(BuildContext context) {
    return ReactiveFormField<DateTime, DateTime>(
      formControlName: widget.formControlName,
      validationMessages: widget.validationMessages,
      builder: (field) {
        final currentValue = field.value;

        if (!_didSetInitialValue &&
            currentValue == null &&
            widget.initialValue != null) {
          _didSetInitialValue = true;
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              field.didChange(widget.initialValue);
            }
          });
        }

        final effectiveValue = currentValue ?? widget.initialValue;

        final formattedDate = effectiveValue == null
            ? null
            : DateFormat(widget.dateFormat).format(effectiveValue);

        Future<void> pickDate() async {
          FocusManager.instance.primaryFocus?.unfocus();

          final now = DateTime.now();

          final pickerInitialDate =
              effectiveValue ??
              widget.initialDate ??
              widget.initialValue ??
              now;

          final safeFirstDate = widget.firstDate ?? DateTime(1900);
          final safeLastDate = widget.lastDate ?? DateTime(2100);

          final normalizedInitialDate =
              pickerInitialDate.isBefore(safeFirstDate)
              ? safeFirstDate
              : pickerInitialDate.isAfter(safeLastDate)
              ? safeLastDate
              : pickerInitialDate;

          final picked = await showDatePicker(
            context: context,
            locale: widget.locale,
            initialDate: normalizedInitialDate,
            firstDate: safeFirstDate,
            lastDate: safeLastDate,
            builder: (context, child) {
              return Theme(
                data: Theme.of(context).copyWith(
                  colorScheme: const ColorScheme.light(
                    primary: AppColorManager.primaryColor,
                  ),
                ),
                child: child!,
              );
            },
          );

          if (picked != null) {
            field.didChange(picked);
            field.control.markAsTouched();
            widget.onSelected?.call(picked);
          }
        }

        final hasError = field.errorText != null && field.control.touched;

        return GestureDetector(
          onTap: pickDate,
          child: AbsorbPointer(
            child: TextField(
              readOnly: true,
              style:
                  widget.inputTextStyle ??
                  TextStyleManager.font14Medium(context),
              controller: TextEditingController(text: formattedDate ?? ''),
              decoration: InputDecoration(
                labelText: widget.lableText,
                labelStyle:
                    widget.labelStyle ??
                    TextStyleManager.font14GrayRegular(context),
                isDense: true,
                contentPadding: widget.contentPadding,
                focusedBorder:
                    widget.focusedBorder ??
                    OutlineInputBorder(
                      borderSide: const BorderSide(
                        color: AppColorManager.primaryColor,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                enabledBorder:
                    widget.enabledBorder ??
                    OutlineInputBorder(
                      borderSide: BorderSide(
                        color: widget.enabledBorderColor ?? Colors.transparent,
                        width: 1.3,
                      ),
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                errorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                focusedErrorBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.red, width: 1.3),
                  borderRadius: BorderRadius.circular(16.0),
                ),
                errorText: hasError ? field.errorText : null,
                errorStyle: TextStyleManager.font13LighRedRegularError(context),
                hintStyle: TextStyleManager.font14LightGrayRegular(context),
                hintText: widget.hintText,
                suffixIcon:
                    widget.suffixIcon ??
                    const Icon(
                      Icons.calendar_month_outlined,
                      color: AppColorManager.primaryColor,
                    ),
                prefixIcon: widget.prefixIcon,
                fillColor:
                    widget.backgroundColor ??
                    AppColorManager.backGroundFeildColor,
                filled: true,
              ),
            ),
          ),
        );
      },
    );
  }
}
