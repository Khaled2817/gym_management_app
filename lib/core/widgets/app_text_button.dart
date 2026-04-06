import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';

class AppTextButton extends StatelessWidget {
  final double? borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final LinearGradient? backgroundGradient; // ✅ NEW
  final double? horizontalPadding;
  final double? verticalPadding;
  final double? buttonWidth;
  final double? buttonHeight;
  final String buttonText;
  final TextStyle textStyle;
  final VoidCallback onPressed;

  const AppTextButton({
    super.key,
    this.borderRadius,
    this.backgroundColor,
    this.backgroundGradient,
    this.borderColor,
    this.horizontalPadding,
    this.verticalPadding,
    this.buttonHeight,
    this.buttonWidth,
    required this.buttonText,
    required this.textStyle,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;
    final radius = BorderRadius.circular(borderRadius ?? 16.0);

    return Container(
      width: buttonWidth?.w ?? double.infinity,
      height: buttonHeight ?? 50.h,
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colors.transparent,
          width: borderColor != null ? 1.3 : 0,
        ),
        borderRadius: radius,
        // ✅ لو فيه Gradient استخدمه، غير كده استخدم اللون الأساسي
        gradient: backgroundGradient,
        color: backgroundGradient == null
            ? (backgroundColor ?? primaryColor)
            : null,
      ),
      child: TextButton(
        style: ButtonStyle(
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(borderRadius: radius),
          ),
          // ✅ خلي الزر شفاف عشان يظهر الـ Container اللي وراه
          backgroundColor: const MaterialStatePropertyAll(Colors.transparent),
          // ✅ إزالة الـ overlay الرمادي الافتراضي (اختياري)
          overlayColor: MaterialStatePropertyAll(
            Colors.white.withValues(alpha: 0.08),
          ),
          padding: MaterialStateProperty.all<EdgeInsets>(
            EdgeInsets.symmetric(
              horizontal: horizontalPadding?.w ?? 12.w,
              vertical: verticalPadding?.h ?? 14.h,
            ),
          ),
          // ✅ fixedSize هنا مش ضروري لأن الكونتينر محدد، لكن نسيبه لو حابب
          fixedSize: MaterialStateProperty.all(
            Size(buttonWidth?.w ?? double.maxFinite, buttonHeight ?? 50.h),
          ),
        ),
        onPressed: onPressed,
        child: Text(buttonText.tr(), style: textStyle),
      ),
    );
  }
}
