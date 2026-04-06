import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:reactive_forms/reactive_forms.dart';

class AppReactiveTextFormField extends StatelessWidget {
  final String formControlName;

  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final Function(String)? onChanged;
  final String hintText;
  final String? lableText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final Color? enabledBorderColor;
  final int? maxLength;
  final int? maxLines;
  final int? minLines;

  /// ✅ اختياري: لو عايز رسائل مخصصة
  final Map<String, String Function(Object)>? validationMessages;

  /// ✅ اختياري: keyboard type / action
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;

  const AppReactiveTextFormField({
    super.key,
    required this.formControlName,
    this.contentPadding,
    this.focusedBorder,
    this.labelStyle,
    this.maxLength,
    this.maxLines,
    this.minLines,
    this.enabledBorder,
    this.onChanged,
    this.enabledBorderColor,
    this.prefixIcon,
    this.lableText,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.validationMessages,
    this.keyboardType,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;
    final lighterGray = isDark
        ? AppColorManagerDark.lighterGray
        : AppColorManager.lighterGray;
    final fillColor = isDark
        ? AppColorManagerDark.backGroundFeildColor
        : AppColorManager.backGroundFeildColor;
    final errorColor = isDark ? AppColorManagerDark.red : Colors.red;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: ReactiveTextField<String>(
        maxLength: maxLength,
        maxLines: maxLines ?? 1,
        minLines: minLines,
        onChanged: (control) => onChanged?.call(control.value ?? ''),
        formControlName: formControlName,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        obscureText: isObscureText ?? false,
        style: inputTextStyle ?? TextStyleManager.font14Medium(context),
        validationMessages: validationMessages,
        decoration: InputDecoration(
          labelText: lableText,
          labelStyle: labelStyle ?? TextStyleManager.font14GrayRegular(context),
          isDense: true,
          contentPadding: contentPadding ?? null,
          focusedBorder:
              focusedBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(color: primaryColor, width: 1.3),
                borderRadius: BorderRadius.circular(16.0),
              ),
          enabledBorder:
              enabledBorder ??
              OutlineInputBorder(
                borderSide: BorderSide(
                  color: enabledBorderColor ?? lighterGray,
                  width: 1.3,
                ),
                borderRadius: BorderRadius.circular(16.0),
              ),
          errorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 1.3),
            borderRadius: BorderRadius.circular(16.0),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorColor, width: 1.3),
            borderRadius: BorderRadius.circular(16.0),
          ),
          errorStyle: TextStyleManager.font13LighRedRegularError(context),
          hintStyle:
              hintStyle ?? TextStyleManager.font14LightGrayRegular(context),
          hintText: hintText,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          fillColor: backgroundColor ?? fillColor,
          filled: true,
        ),
      ),
    );
  }
}
