import 'package:escape/features/temptation/services/temptation_storage_service.dart';
import 'package:escape/providers/user_profile_provider.dart';
import 'package:escape/providers/has_active_temptation_provider.dart';
import 'package:escape/providers/current_active_temptation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'objectbox_provider.dart';
import '../theme/theme_provider.dart';

part 'app_startup_provider.g.dart';

/// A provider that handles app initialization and manages the app startup state
@Riverpod(keepAlive: true)
class AppStartup extends _$AppStartup {
  @override
  Future<bool> build() async {
    // Start with loading state, then initialize
    return await _initializeApp();
  }

  /// Initialize all required dependencies for the app
  Future<bool> _initializeApp() async {
    try {
      // Initialize ObjectBox provider
      await ref.read(objectboxProvider.future);

      // Initialize user profile provider
      await ref.read(userProfileProvider.future);

      // Initialize theme provider
      await ref.read(themeModeNotifierProvider.future);

      // Initialize temptation shared pref service
      await TemptationStorageService().initialize();

      // Initialize temptation providers
      ref.read(hasActiveTemptationProvider);
      ref.read(currentActiveTemptationProvider);

      // Add any other initialization code here
      // For example:
      // await ref.watch(otherProvider.future);

      // Simulate any additional async work if needed
      await Future.delayed(const Duration(seconds: 1));

      return true;
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
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await _initializeApp();
      return true;
    });
  }
}
