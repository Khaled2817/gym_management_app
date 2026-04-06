import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/font_weight_helper.dart';

class TextStyleManager {
  // ✅ غيّر _arFont لاسم الخط العربي عندك في pubspec.yaml
  static const String _enFont = 'Inter';
  static const String _arFont = 'Tajawal';

  static String _fontFamily(BuildContext context) {
    return context.locale.languageCode == 'ar' ? _arFont : _enFont;
  }

  static TextStyle _style(
    BuildContext context, {
    required double fontSize,
    required FontWeight fontWeight,
    Color? color,
  }) {
    return TextStyle(
      fontFamily: _fontFamily(context),
      fontSize: fontSize.sp,
      fontWeight: fontWeight,
      color: color,
    );
  }

  static bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  static Color _defaultTextColor(BuildContext context) =>
      Theme.of(context).textTheme.bodyMedium?.color ??
      (_isDark(context) ? Colors.white : Colors.black);

  static Color _primaryColor(BuildContext context) => _isDark(context)
      ? AppColorManagerDark.primaryColor
      : AppColorManager.primaryColor;

  static Color _secondaryColor(BuildContext context) => _isDark(context)
      ? AppColorManagerDark.secondaryColor
      : AppColorManager.secondaryColor;

  static Color _grayTextColor(BuildContext context) => _isDark(context)
      ? AppColorManagerDark.greyText
      : AppColorManager.greyText;

  static Color _grayColor(BuildContext context) =>
      _isDark(context) ? AppColorManagerDark.gray : AppColorManager.gray;

  static Color _redColor(BuildContext context) =>
      _isDark(context) ? AppColorManagerDark.red : AppColorManager.red;

  static Color _lightGrayColor(BuildContext context) => _isDark(context)
      ? AppColorManagerDark.lightGray
      : AppColorManager.lightGray;

  static Color _darkAccentColor(BuildContext context) => _isDark(context)
      ? AppColorManagerDark.darkDegradadoAzul
      : AppColorManager.darkDegradadoAzul;

  static TextStyle font24BlackBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: _defaultTextColor(context),
  );
  static TextStyle font12MediumsecondaryColor(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.bold,
    color: _secondaryColor(context),
  );
  static TextStyle font24Bold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );
  static TextStyle font16Medium(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: _primaryColor(context),
  );
  static TextStyle font12Medium(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.medium,
    color: _primaryColor(context),
  );
  static TextStyle font16SemiBold(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );
  static TextStyle font18DarkBlueBold(BuildContext context) => _style(
    context,
    fontSize: 18,
    fontWeight: FontWeightHelper.bold,
    color: _defaultTextColor(context),
  );
  static TextStyle font16Bold(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );

  static TextStyle font32Bold(BuildContext context) =>
      _style(context, fontSize: 32, fontWeight: FontWeightHelper.bold);

  static TextStyle font36Bold(BuildContext context) =>
      _style(context, fontSize: 36, fontWeight: FontWeightHelper.bold);

  static TextStyle font16BoldWhite(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.bold,
    color: AppColorManager.white,
  );
  static TextStyle font15SemiBold(BuildContext context) => _style(
    context,
    fontSize: 15,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );
  static TextStyle fontt13SemiBold(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );
  static TextStyle fontt12SemiBold(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );
  static TextStyle font13LighRedRegularError(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: _redColor(context),
  );
  static TextStyle font15SemiBoldGary(BuildContext context) => _style(
    context,
    fontSize: 15,
    fontWeight: FontWeightHelper.bold,
    color: _grayTextColor(context),
  );
  static TextStyle font13SemiBoldGary(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.bold,
    color: _grayTextColor(context),
  );

  static TextStyle font16Boldinter(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );

  static TextStyle font32DegradadoAzulBold(BuildContext context) => _style(
    context,
    fontSize: 32,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );

  static TextStyle font24WhiteMed(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: AppColorManager.white,
  );

  static TextStyle font13DegradadoAzulSemiBold(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font13Medium(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.medium,
    color: _darkAccentColor(context),
  );

  static TextStyle font20DegradadoAzulMedium(BuildContext context) => _style(
    context,
    fontSize: 20,
    fontWeight: FontWeightHelper.medium,
    color: _primaryColor(context),
  );

  static TextStyle font13DarkDegradadoAzulRegular(BuildContext context) =>
      _style(
        context,
        fontSize: 13,
        fontWeight: FontWeightHelper.regular,
        color: _darkAccentColor(context),
      );

  static TextStyle font24DegradadoAzulBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: _primaryColor(context),
  );

  static TextStyle font16WhiteSemiBold(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );

  static TextStyle font16DegradadoAzuSemiBold(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font32DegradadoAzulSemiBold(BuildContext context) => _style(
    context,
    fontSize: 32,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font24WhiteSemiBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.semiBold,
    color: Colors.white,
  );
  static TextStyle font24SemiBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font20WhiteSemiBold(BuildContext context) => _style(
    context,
    fontSize: 20,
    fontWeight: FontWeightHelper.semiBold,
    color: _defaultTextColor(context),
  );

  static TextStyle font20WDegradadoAzulMedium(BuildContext context) => _style(
    context,
    fontSize: 20,
    fontWeight: FontWeightHelper.medium,
    color: _darkAccentColor(context),
  );

  static TextStyle font13GrayRegular(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: _grayTextColor(context),
  );
  static TextStyle font16GraySemiBold(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.semiBold,
    color: _grayTextColor(context),
  );
  static TextStyle font16GrayMedium(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: _grayTextColor(context),
  );

  static TextStyle font12GrayRegular(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: _grayTextColor(context),
  );

  static TextStyle font12GrayMedium(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.medium,
    color: _grayTextColor(context),
  );

  static TextStyle font12DarkDegradadoAzulRegular(BuildContext context) =>
      _style(
        context,
        fontSize: 12,
        fontWeight: FontWeightHelper.regular,
        color: _darkAccentColor(context),
      );

  static TextStyle font12DegradadoAzulRegular(BuildContext context) => _style(
    context,
    fontSize: 12,
    fontWeight: FontWeightHelper.regular,
    color: _primaryColor(context),
  );

  static TextStyle font15WhiteRegular(BuildContext context) => _style(
    context,
    fontSize: 15,
    fontWeight: FontWeightHelper.regular,
    color: AppColorManager.white,
  );

  static TextStyle font14Regular(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: _primaryColor(context),
  );

  static TextStyle font13DegradadoAzulRegular(BuildContext context) => _style(
    context,
    fontSize: 13,
    fontWeight: FontWeightHelper.regular,
    color: _primaryColor(context),
  );

  static TextStyle font14GrayRegular(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: _grayColor(context),
  );

  static TextStyle font14LightGrayRegular(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.regular,
    color: _lightGrayColor(context),
  );

  static TextStyle font14Medium(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.medium,
    color: _primaryColor(context),
  );
  static TextStyle font14GrayMedium(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.medium,
    color: _grayTextColor(context),
  );

  static TextStyle font14DarkDegradadoAzulBold(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.bold,
    color: _darkAccentColor(context),
  );

  static TextStyle font16WhiteMedium(BuildContext context) => _style(
    context,
    fontSize: 16,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );

  static TextStyle font24WhiteBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.bold,
    color: Colors.white,
  );

  static TextStyle font14SemiBold(BuildContext context) => _style(
    context,
    fontSize: 14,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font14DegradadoAzulMedium(BuildContext context) => _style(
    context,
    fontSize: 15,
    fontWeight: FontWeightHelper.medium,
    color: _primaryColor(context),
  );

  static TextStyle font24DegradadoAzulSemiBold(BuildContext context) => _style(
    context,
    fontSize: 24,
    fontWeight: FontWeightHelper.semiBold,
    color: _primaryColor(context),
  );

  static TextStyle font15DarkDegradadoAzulMedium(BuildContext context) =>
      _style(
        context,
        fontSize: 15,
        fontWeight: FontWeightHelper.medium,
        color: _darkAccentColor(context),
      );

  static TextStyle font18DarkDegradadoAzulBold(BuildContext context) => _style(
    context,
    fontSize: 18,
    fontWeight: FontWeightHelper.bold,
    color: _darkAccentColor(context),
  );

  static TextStyle font18DarkDegradadoAzulSemiBold(BuildContext context) =>
      _style(
        context,
        fontSize: 18,
        fontWeight: FontWeightHelper.semiBold,
        color: _darkAccentColor(context),
      );

  static TextStyle font18WhiteMedium(BuildContext context) => _style(
    context,
    fontSize: 18,
    fontWeight: FontWeightHelper.medium,
    color: Colors.white,
  );
}
