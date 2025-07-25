import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/onboarding_data.dart';

class StorageService {
  static const String _onboardingCompleteKey = 'onboarding_complete';
  static const String _onboardingDataKey = 'onboarding_data';

  static Future<bool> isFirstTimeUser() async {
    final prefs = await SharedPreferences.getInstance();
    return !(prefs.getBool(_onboardingCompleteKey) ?? true);
  }

  static Future<void> setOnboardingComplete() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_onboardingCompleteKey, true);
  }

  static Future<OnboardingData?> getOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_onboardingDataKey);
    if (jsonString != null) {
      try {
        final jsonMap = jsonDecode(jsonString) as Map<String, dynamic>;
        return OnboardingData.fromJson(jsonMap);
      } catch (e) {
        debugPrint('Error loading onboarding data: $e');
        return null;
      }
    }
    return null;
  }

  static Future<void> saveOnboardingData(OnboardingData data) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = jsonEncode(data.toJson());
    await prefs.setString(_onboardingDataKey, jsonString);
  }

  static Future<void> clearOnboardingData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_onboardingDataKey);
    await prefs.setBool(_onboardingCompleteKey, false);
  }

  static String _simpleHash(String input) {
    // Simple hash function for demonstration purposes only
    // In a real application, you would use a proper cryptographic hash function
    final salt = 'escape_app_salt';
    final combined = '$input$salt';
    final bytes = utf8.encode(combined);
    final hash = bytes.fold<int>(0, (prev, element) => prev + element);
    return hash.toString();
  }

  static Future<void> savePassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final hashedPassword = _simpleHash(password);
    await prefs.setString('user_password', hashedPassword);
  }

  static Future<bool> verifyPassword(String password) async {
    final prefs = await SharedPreferences.getInstance();
    final storedHash = prefs.getString('user_password');
    if (storedHash == null) return false;
    final inputHash = _simpleHash(password);
    return storedHash == inputHash;
  }
}
