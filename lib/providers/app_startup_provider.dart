import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'objectbox_provider.dart';
import '../theme/theme_provider.dart';

part 'app_startup_provider.g.dart';

/// A provider that handles app initialization and manages the app startup state
@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  @override
  Future<void> build() async {
    // Perform any necessary app initialization here
    // This will be called when the provider is first accessed
    await _initializeApp();
  }

  /// Initialize all required dependencies for the app
  Future<void> _initializeApp() async {
    try {
      // Initialize ObjectBox provider
      await ref.watch(objectboxProvider.future);

      // Initialize theme provider
      await ref.watch(themeModeNotifierProvider.future);

      // Add any other initialization code here
      // For example:
      // await ref.watch(otherProvider.future);

      // Simulate any additional async work if needed
      // await Future.delayed(const Duration(milliseconds: 500));
    } catch (e, st) {
      // Log the error for debugging
      debugPrint('App startup error: $e');
      debugPrintStack(stackTrace: st);

      // Re-throw to let the UI handle the error state
      rethrow;
    }
  }

  /// Retry the initialization process
  Future<void> retry() async {
    // Use AsyncValue.guard to handle the retry logic properly
    state = await AsyncValue.guard(() => _initializeApp());
  }
}
