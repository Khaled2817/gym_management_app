import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';

class AppTextFormField extends StatelessWidget {
  final EdgeInsetsGeometry? contentPadding;
  final InputBorder? focusedBorder;
  final InputBorder? enabledBorder;
  final TextStyle? inputTextStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final String hintText;
  final String? lableText;
  final bool? isObscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final Color? backgroundColor;
  final Color? enabledBorderColor;
  final TextEditingController? controller;

  /// ✅ validator standard
  final String? Function(String?) validator;

  /// ✅ new
  final List<TextInputFormatter>? inputFormatters;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextAlign? textAlign;
  final TextAlignVertical? textAlignVertical;
  final int? maxLength;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  const AppTextFormField({
    super.key,
    this.contentPadding,
    this.focusedBorder,
    this.labelStyle,
    this.enabledBorder,
    this.enabledBorderColor,
    this.prefixIcon,
    this.lableText,
    this.inputTextStyle,
    this.hintStyle,
    required this.hintText,
    this.isObscureText,
    this.suffixIcon,
    this.backgroundColor,
    this.controller,
    required this.validator,
    this.inputFormatters,
    this.keyboardType,
    this.textInputAction,
    this.textAlign,
    this.textAlignVertical,
    this.maxLength,
    this.onChanged,
    this.focusNode,
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
    final errorColor = isDark ? AppColorManagerDark.red : AppColorManager.red;
    final fillColor = isDark
        ? AppColorManagerDark.backGroundFeildColor
        : AppColorManager.backGroundFeildColor;

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      onChanged: onChanged,
      inputFormatters: inputFormatters,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      textAlign: textAlign ?? TextAlign.start,
      textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
      maxLength: maxLength,
      decoration: InputDecoration(
        counterText: '',
        labelText: lableText,
        labelStyle: labelStyle ?? TextStyleManager.font14GrayRegular(context),
        isDense: true,
        contentPadding:
            contentPadding ??
            EdgeInsets.symmetric(horizontal: 20.w, vertical: 18.h),
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
        hintStyle:
            hintStyle ?? TextStyleManager.font14LightGrayRegular(context),
        hintText: hintText,
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        fillColor: backgroundColor ?? fillColor,
        filled: true,
      ),
      cursorColor: primaryColor,
      obscureText: isObscureText ?? false,
      style: inputTextStyle ?? TextStyleManager.font14Medium(context),
      validator: validator,
    );
  }
}
