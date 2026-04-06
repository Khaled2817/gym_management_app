import 'package:flutter/material.dart';

class ThemeStates {
  final ThemeMode themeMode;
  final bool isDarkMode;

  const ThemeStates({
    required this.themeMode,
    required this.isDarkMode,
  });

  factory ThemeStates.initial() {
    return const ThemeStates(
      themeMode: ThemeMode.light,
      isDarkMode: false,
    );
  }

  ThemeStates copyWith({
    ThemeMode? themeMode,
    bool? isDarkMode,
  }) {
    return ThemeStates(
      themeMode: themeMode ?? this.themeMode,
      isDarkMode: isDarkMode ?? this.isDarkMode,
    );
  }
}
