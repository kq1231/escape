import 'package:flutter/material.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeProvider = StateProvider<ThemeMode>((ref) {
  // Default to system theme
  return ThemeMode.system;
});

class ThemeService {
  static const String _themeKey = 'theme_mode';

  static Future<ThemeMode> loadTheme() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey) ?? 'system';
      return _getThemeModeFromString(themeModeString);
    } catch (e) {
      return ThemeMode.system;
    }
  }

  static ThemeMode _getThemeModeFromString(String themeModeString) {
    switch (themeModeString) {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      case 'system':
      default:
        return ThemeMode.system;
    }
  }

  static String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }

  static Future<void> saveTheme(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _getStringFromThemeMode(themeMode));
  }
}
