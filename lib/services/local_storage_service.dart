import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/app_data.dart';

class LocalStorageService {
  static const String _appDataKey = 'app_data';

  // Save app data
  static Future<void> saveAppData(AppData appData) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(appData.toJson());
    await prefs.setString(_appDataKey, jsonString);
  }

  // Load app data
  static Future<AppData?> loadAppData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_appDataKey);

    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return AppData.fromJson(jsonMap);
      } catch (e) {
        // Handle JSON parsing errors
        return null;
      }
    }

    return null;
  }

  // Clear app data
  static Future<void> clearAppData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_appDataKey);
  }

  // Save a simple string value
  static Future<void> saveString(String key, String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  // Load a simple string value
  static Future<String?> loadString(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  // Save a simple bool value
  static Future<void> saveBool(String key, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(key, value);
  }

  // Load a simple bool value
  static Future<bool?> loadBool(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(key);
  }

  // Save a simple int value
  static Future<void> saveInt(String key, int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(key, value);
  }

  // Load a simple int value
  static Future<int?> loadInt(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(key);
  }
}
