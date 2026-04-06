import 'package:gym_management_app/core/api/token_storage.dart';
import 'package:gym_management_app/core/notifications/attendance_notification_service.dart';
import 'package:gym_management_app/core/routing/routers.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';
import 'package:gym_management_app/core/theming/styles.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_cubit.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_states.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  // Helper method to get primary color based on theme
  Color _getPrimaryColor(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return isDark
        ? AppColorManagerDark.primaryColor
        : AppColorManager.primaryColor;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'settings'.tr(),
          style: TextStyleManager.font18WhiteMedium(context),
        ),
        centerTitle: true,
        leading: SizedBox.shrink(),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          children: [
            _buildThemeToggleCard(context),
            SizedBox(height: 12.h),
            _buildLanguageCard(context),
            SizedBox(height: 12.h),
            _buildLogoutCard(context),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeToggleCard(BuildContext context) {
    final primaryColor = _getPrimaryColor(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.dark_mode_outlined,
              color: primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'dark_mode'.tr(),
                  style: TextStyleManager.font16DegradadoAzuSemiBold(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  'dark_mode_desc'.tr(),
                  style: TextStyleManager.font12GrayRegular(context),
                ),
              ],
            ),
          ),
          BlocBuilder<ThemeCubit, ThemeStates>(
            builder: (context, state) {
              return Switch(
                value: state.isDarkMode,
                activeColor: primaryColor,
                onChanged: (value) {
                  context.read<ThemeCubit>().toggleTheme();
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageCard(BuildContext context) {
    final primaryColor = _getPrimaryColor(context);
    final currentLocale = context.locale;
    final isArabic = currentLocale.languageCode == 'ar';

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.black.withValues(alpha: 0.3)
                : Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: primaryColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(
              Icons.translate_outlined,
              color: primaryColor,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'language'.tr(),
                  style: TextStyleManager.font16DegradadoAzuSemiBold(context),
                ),
                SizedBox(height: 4.h),
                Text(
                  isArabic ? 'العربية' : 'English',
                  style: TextStyleManager.font12GrayRegular(context),
                ),
              ],
            ),
          ),
          _buildLanguageToggleButton(context, isArabic, primaryColor),
        ],
      ),
    );
  }

  Widget _buildLanguageToggleButton(
    BuildContext context,
    bool isArabic,
    Color primaryColor,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: primaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(25.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildLangButton(
            context: context,
            label: 'ع',
            isSelected: isArabic,
            primaryColor: primaryColor,
            onTap: () => _changeLanguage(context, const Locale('ar')),
          ),
          _buildLangButton(
            context: context,
            label: 'En',
            isSelected: !isArabic,
            primaryColor: primaryColor,
            onTap: () => _changeLanguage(context, const Locale('en')),
          ),
        ],
      ),
    );
  }

  Widget _buildLangButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required Color primaryColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: isSelected ? primaryColor : Colors.transparent,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : primaryColor,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 14.sp,
          ),
        ),
      ),
    );
  }

  void _changeLanguage(BuildContext context, Locale locale) async {
    await context.setLocale(locale);
  }

  Widget _buildLogoutCard(BuildContext context) {
    return GestureDetector(
      onTap: () => _showLogoutDialog(context),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(12.r),
          boxShadow: [
            BoxShadow(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.black.withValues(alpha: 0.3)
                  : Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Icon(
                Icons.logout_outlined,
                color: Colors.red,
                size: 24.sp,
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Text(
                'logout'.tr(),
                style: TextStyleManager.font16DegradadoAzuSemiBold(context),
              ),
            ),
            Icon(Icons.arrow_forward_ios, color: Colors.red, size: 18.sp),
          ],
        ),
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('logout'.tr()),
        content: Text('logout_confirm'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text('cancel'.tr()),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(dialogContext);
              await _logout(context);
            },
            child: Text('logout'.tr(), style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Cancel all notifications
    await AttendanceNotificationService.instance
        .cancelAllAttendanceNotifications();
    // Clear login data
    await TokenStorage.clearLoginData();
    // Navigate to login screen
    if (context.mounted) {
      Navigator.pushNamedAndRemoveUntil(
        context,
        Routers.loginScreen,
        (route) => false,
      );
    }
  }
}
