import 'dart:ui';

import 'package:flutter/material.dart';

class AppColorManager {
  // Primary colors from logo
  static const Color primaryColor = Color(0xFF0052A5);
  static const Color secondaryColor = Color(0xFF0095FF);
  static const Color accentColor = Color(0xFF003366);

  static const Color secondaryColorlight = Color(0xFFE6F3FF);
  static const Color lightBlue = Color(0xFF0095FF);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color red = Color(0xFFFF0000);
  static const Color green = Color(0xFF00FF00);
  static const Color borderColor = Color(0xFFE1E1E1);
  static const Color greyText = Color(0xFFA1A8B0);
  static const Color grey = Color(0xFFC4C4C4);
  static const Color mainBlue = Color(0xFF0052A5);
  static const Color lightDegradadoAzul = Color(0xFFF4F8FF);
  static const Color darkDegradadoAzul = Color(0xFF003366);
  static const Color gray = Color(0xFF757575);
  static const Color lightGray = Color(0xFFC2C2C2);
  static const Color lighterGray = Color(0xFFEDEDED);
  static const Color moreLightGray = Color(0xFFFDFDFF);
  static const Color moreLighterGray = Color(0xFFF5F5F5);
  static const Color backGroundFeildColor = Color(0xFFE6F3FF);
  static const LinearGradient primaryLinearGradient = LinearGradient(
    colors: [
      primaryColor,
      secondaryColor,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient secondLinearGradient = LinearGradient(
    colors: [
      secondaryColor,
      secondaryColor,
      secondaryColor,
      secondaryColorlight,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}

// Dark Theme Colors
class AppColorManagerDark {
  // Primary colors from logo (adjusted for dark mode)
  static const Color primaryColor = Color(0xFF0095FF);
  static const Color secondaryColor = Color(0xFF0052A5);
  static const Color accentColor = Color(0xFF003366);

  static const Color secondaryColorlight = Color(0xFF1A3A5C);
  static const Color lightBlue = Color(0xFF0095FF);
  static const Color white = Color(0xFF1E1E1E);
  static const Color black = Color(0xFFFFFFFF);
  static const Color red = Color(0xFFFF5555);
  static const Color green = Color(0xFF50FA7B);
  static const Color borderColor = Color(0xFF3A3A3A);
  static const Color greyText = Color(0xFFB0B0B0);
  static const Color grey = Color(0xFF4A4A4A);
  static const Color mainBlue = Color(0xFF0095FF);
  static const Color lightDegradadoAzul = Color(0xFF1A2A3A);
  static const Color darkDegradadoAzul = Color(0xFF003366);
  static const Color gray = Color(0xFFA0A0A0);
  static const Color lightGray = Color(0xFF3D3D3D);
  static const Color lighterGray = Color(0xFF2A2A2A);
  static const Color moreLightGray = Color(0xFF252525);
  static const Color moreLighterGray = Color(0xFF1A1A1A);
  static const Color backGroundFeildColor = Color(0xFF1A2A3A);
  static const Color scaffoldBackground = Color(0xFF121212);
  static const Color cardBackground = Color(0xFF1E1E1E);
  static const LinearGradient primaryLinearGradient = LinearGradient(
    colors: [
      primaryColor,
      secondaryColor,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
  static const LinearGradient secondLinearGradient = LinearGradient(
    colors: [
      secondaryColor,
      secondaryColor,
      secondaryColor,
      secondaryColorlight,
    ],
    begin: Alignment.centerLeft,
    end: Alignment.centerRight,
  );
}