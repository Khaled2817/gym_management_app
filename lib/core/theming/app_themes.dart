import 'package:flutter/material.dart';
import 'package:gym_management_app/core/theming/app_color_manager.dart';

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColorManager.primaryColor,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.light(
        primary: AppColorManager.primaryColor,
        secondary: AppColorManager.secondaryColor,
        surface: Colors.white,
        error: AppColorManager.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorManager.primaryColor,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(color: Colors.white, elevation: 2),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorManager.backGroundFeildColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManager.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManager.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManager.primaryColor),
        ),
      ),
      dividerColor: AppColorManager.borderColor,
      iconTheme: IconThemeData(color: AppColorManager.gray),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      primaryColor: AppColorManagerDark.primaryColor,
      scaffoldBackgroundColor: AppColorManagerDark.scaffoldBackground,
      colorScheme: ColorScheme.dark(
        primary: AppColorManagerDark.primaryColor,
        secondary: AppColorManagerDark.secondaryColor,
        surface: AppColorManagerDark.cardBackground,
        error: AppColorManagerDark.red,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: AppColorManagerDark.cardBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      cardTheme: CardThemeData(
        color: AppColorManagerDark.cardBackground,
        elevation: 2,
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColorManagerDark.backGroundFeildColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManagerDark.borderColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManagerDark.borderColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: AppColorManagerDark.primaryColor),
        ),
      ),
      dividerColor: AppColorManagerDark.borderColor,
      iconTheme: IconThemeData(color: AppColorManagerDark.gray),
    );
  }
}
