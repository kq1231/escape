import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const String _isAuthenticatedKey = 'is_authenticated';
  static const String _lastAuthTimeKey = 'last_auth_time';
  static const String _authTimeoutMinutes = 'auth_timeout_minutes';
  
  static final LocalAuthentication _localAuth = LocalAuthentication();
  
  /// Check if user is currently authenticated (within timeout period)
  static Future<bool> isAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    final isAuth = prefs.getBool(_isAuthenticatedKey) ?? false;
    
    if (!isAuth) return false;
    
    // Check if authentication has expired
    final lastAuthTime = prefs.getInt(_lastAuthTimeKey) ?? 0;
    final timeoutMinutes = prefs.getInt(_authTimeoutMinutes) ?? 30; // Default 30 minutes
    final currentTime = DateTime.now().millisecondsSinceEpoch;
    final timeDifference = currentTime - lastAuthTime;
    final timeoutMillis = timeoutMinutes * 60 * 1000;
    
    if (timeDifference > timeoutMillis) {
      // Authentication expired
      await _clearAuthentication();
      return false;
    }
    
    return true;
  }
  
  /// Verify password against stored hash
  static Future<bool> verifyPassword(String password, String storedHash) async {
    final inputHash = _hashPassword(password);
    return inputHash == storedHash;
  }
  
  /// Hash password using simple hash function (matches onboarding)
  static String _hashPassword(String password) {
    const salt = 'escape_app_salt';
    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final hash = bytes.fold<int>(0, (prev, element) => prev + element);
    return hash.toString();
  }
  
  /// Check if biometric authentication is available
  static Future<bool> isBiometricAvailable() async {
    try {
      final isAvailable = await _localAuth.canCheckBiometrics;
      final isDeviceSupported = await _localAuth.isDeviceSupported();
      return isAvailable && isDeviceSupported;
    } catch (e) {
      debugPrint('Error checking biometric availability: $e');
      return false;
    }
  }
  
  /// Get available biometric types
  static Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _localAuth.getAvailableBiometrics();
    } catch (e) {
      debugPrint('Error getting available biometrics: $e');
      return [];
    }
  }
  
  /// Authenticate using biometrics
  static Future<bool> authenticateWithBiometrics() async {
    try {
      final isAvailable = await isBiometricAvailable();
      if (!isAvailable) return false;
      
      final didAuthenticate = await _localAuth.authenticate(
        localizedReason: 'Please authenticate to access the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (didAuthenticate) {
        await _setAuthenticated();
      }
      
      return didAuthenticate;
    } on PlatformException catch (e) {
      debugPrint('Biometric authentication error: $e');
      return false;
    } catch (e) {
      debugPrint('Unexpected biometric authentication error: $e');
      return false;
    }
  }
  
  /// Authenticate using password
  static Future<bool> authenticateWithPassword(String password, String storedHash) async {
    final isValid = await verifyPassword(password, storedHash);
    if (isValid) {
      await _setAuthenticated();
    }
    return isValid;
  }
  
  /// Set user as authenticated
  static Future<void> _setAuthenticated() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, true);
    await prefs.setInt(_lastAuthTimeKey, DateTime.now().millisecondsSinceEpoch);
  }
  
  /// Clear authentication state
  static Future<void> _clearAuthentication() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isAuthenticatedKey, false);
    await prefs.remove(_lastAuthTimeKey);
  }
  
  /// Logout user
  static Future<void> logout() async {
    await _clearAuthentication();
  }
  
  /// Set authentication timeout in minutes
  static Future<void> setAuthTimeout(int minutes) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_authTimeoutMinutes, minutes);
  }
  
  /// Get current authentication timeout in minutes
  static Future<int> getAuthTimeout() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_authTimeoutMinutes) ?? 30;
  }
}
