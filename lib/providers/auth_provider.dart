import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escape/services/auth_service.dart';

part 'auth_provider.g.dart';

@Riverpod(keepAlive: true)
class Auth extends _$Auth {
  @override
  Future<bool> build() async {
    // Check if user is already authenticated
    return await AuthService.isAuthenticated();
  }

  /// Authenticate with password
  Future<bool> authenticateWithPassword(String password, String storedHash) async {
    final isAuthenticated = await AuthService.authenticateWithPassword(password, storedHash);
    if (isAuthenticated) {
      state = const AsyncValue.data(true);
    }
    return isAuthenticated;
  }

  /// Authenticate with biometrics
  Future<bool> authenticateWithBiometrics() async {
    final isAuthenticated = await AuthService.authenticateWithBiometrics();
    if (isAuthenticated) {
      state = const AsyncValue.data(true);
    }
    return isAuthenticated;
  }

  /// Logout user
  Future<void> logout() async {
    await AuthService.logout();
    state = const AsyncValue.data(false);
  }

  /// Check if biometric authentication is available
  Future<bool> isBiometricAvailable() async {
    return await AuthService.isBiometricAvailable();
  }

  /// Set authentication timeout
  Future<void> setAuthTimeout(int minutes) async {
    await AuthService.setAuthTimeout(minutes);
  }

  /// Get authentication timeout
  Future<int> getAuthTimeout() async {
    return await AuthService.getAuthTimeout();
  }

  /// Force refresh authentication state
  Future<void> refreshAuthState() async {
    state = const AsyncValue.loading();
    state = AsyncValue.data(await AuthService.isAuthenticated());
  }
}
