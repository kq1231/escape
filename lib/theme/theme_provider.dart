import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

@Riverpod(keepAlive: true)
class ThemeModeNotifier extends _$ThemeModeNotifier {
  static const String _themeKey = 'theme_mode';

  @override
  Future<ThemeMode> build() async {
    // Load the saved theme mode from shared preferences
    return _loadThemeMode();
  }

  /// Load the theme mode from shared preferences
  Future<ThemeMode> _loadThemeMode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final themeModeString = prefs.getString(_themeKey) ?? 'system';
      return _getThemeModeFromString(themeModeString);
    } catch (e) {
      // If there's an error loading, default to system theme
      return ThemeMode.system;
    }
  }

  /// Save the theme mode to shared preferences
  Future<void> saveThemeMode(ThemeMode themeMode) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_themeKey, _getStringFromThemeMode(themeMode));
    // Update the state
    state = AsyncData(themeMode);
  }

  /// Toggle between light and dark theme (for demo purposes)
  Future<void> toggleThemeMode() async {
    final currentTheme = state.asData?.value ?? ThemeMode.system;
    final newTheme = currentTheme == ThemeMode.light
        ? ThemeMode.dark
        : ThemeMode.light;
    await saveThemeMode(newTheme);
  }

  /// Helper method to convert string to ThemeMode
  ThemeMode _getThemeModeFromString(String themeModeString) {
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

  /// Helper method to convert ThemeMode to string
  String _getStringFromThemeMode(ThemeMode themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'light';
      case ThemeMode.dark:
        return 'dark';
      case ThemeMode.system:
        return 'system';
    }
  }
}
