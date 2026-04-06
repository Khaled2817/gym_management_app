import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:gym_management_app/core/storage/shared_pref_helper.dart';
import 'package:gym_management_app/core/storage/shared_pref_keys.dart';
import 'package:gym_management_app/feature/settings/logic/cubit/theme_states.dart';

class ThemeCubit extends Cubit<ThemeStates> {
  ThemeCubit() : super(ThemeStates.initial()) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final isDarkMode = await SharedPrefHelper.getBool(
      SharedPrefKeys.isDarkMode,
    );
    emit(
      ThemeStates(
        themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,
        isDarkMode: isDarkMode,
      ),
    );
  }

  Future<void> toggleTheme() async {
    final newIsDarkMode = !state.isDarkMode;
    await SharedPrefHelper.setData(SharedPrefKeys.isDarkMode, newIsDarkMode);
    emit(
      state.copyWith(
        themeMode: newIsDarkMode ? ThemeMode.dark : ThemeMode.light,
        isDarkMode: newIsDarkMode,
      ),
    );
  }

  void setThemeMode(ThemeMode mode) {
    final isDark = mode == ThemeMode.dark;
    SharedPrefHelper.setData(SharedPrefKeys.isDarkMode, isDark);
    emit(state.copyWith(themeMode: mode, isDarkMode: isDark));
  }
}
