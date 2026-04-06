import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/helpers/spacing_helper.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/onboarding/ui/widget/login_button.dart';
import 'package:gym_management_app/feature/onboarding/ui/widget/phone_image_and_text.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const PhoneImageAndText(),
                  verticalSpace(45.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.w),
                    child: Column(
                      children: [
                        Text(
                          'onboarding_subtitle'.tr(),
                          style: TextStyleManager.font16GraySemiBold(context),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 30.h),
                        LoginButton(),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // زرار تغيير اللغة الرايق
            Positioned(
              top: 16.h,
              right: 16.w,
              child: _buildLanguageToggle(context, primaryColor),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageToggle(BuildContext context, Color primaryColor) {
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(25.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangChip(
            context: context,
            label: 'العربية',
            isSelected: isArabic,
            primaryColor: primaryColor,
            onTap: () => _changeLanguage(context, const Locale('ar')),
          ),
          _buildLangChip(
            context: context,
            label: 'English',
            isSelected: !isArabic,
            primaryColor: primaryColor,
            onTap: () => _changeLanguage(context, const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildLangChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.h),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColorManager.primaryLinearGradient : null,
          color: isSelected ? null : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected
                ? Colors.white
                : (Theme.of(context).brightness == Brightness.dark
                      ? Colors.white70
                      : Colors.black54),
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            fontSize: 13.sp,
          ),
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
  }
}
