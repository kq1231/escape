import 'package:escape/models/temptation.dart';
import 'package:escape/features/temptation/services/temptation_storage_service.dart';
import 'package:escape/repositories/temptation_repository.dart';
import 'package:escape/providers/streak_provider.dart';
import 'package:escape/providers/has_active_temptation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_active_temptation_provider.g.dart';

/// Provider for the current active temptation (if any)
/// Used in the temptation flow screen to manage temptation state
/// keepAlive: false because it's only used during active temptation sessions
@Riverpod(keepAlive: false)
class CurrentActiveTemptation extends _$CurrentActiveTemptation {
  late TemptationStorageService _storageService;

  @override
  Future<Temptation?> build() async {
    // Initialize the storage service in case it is not already initialized
    _storageService = TemptationStorageService();
    await _storageService.initialize();

    // Fetch active temptation from SharedPreferences
    return _fetchActiveTemptation();
  }

  /// Fetch active temptation from SharedPreferences and create Temptation object
  Future<Temptation?> _fetchActiveTemptation() async {
    final temptationId = _storageService.getActiveTemptationId();
    if (temptationId == null) return null;

    // Get the full temptation from ObjectBox
    return ref
        .read(temptationRepositoryProvider.notifier)
        .getTemptationById(temptationId);
  }

  /// Complete temptation and save to ObjectBox
  Future<void> completeTemptation({required Temptation temptation}) async {
    try {
      // Save to ObjectBox
      await ref
          .read(temptationRepositoryProvider.notifier)
          .updateTemptation(temptation);

      // Handle streak upsert
      if (temptation.wasSuccessful) {
        // Do nothing to streak, user will have to manually increment
        // it at the end of the day
      } else {
        // Relapse - reset streak to zero
        await _upsertStreakForRelapse();
      }

      // Clear active temptation from SharedPreferences
      await _storageService.clearActiveTemptation();

      // Refresh state and invalidate hasActiveTemptation provider
      ;
      ref.invalidate(hasActiveTemptationProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Cancel temptation (remove data from shared prefs without saving to ObjectBox)
  Future<void> cancelTemptation() async {
    try {
      // Clear active temptation from SharedPreferences
      await _storageService.clearActiveTemptation();

      // Refresh state and invalidate hasActiveTemptation provider
      ;
      ref.invalidate(hasActiveTemptationProvider);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Upsert streak for relapse (reset to zero)
  Future<void> _upsertStreakForRelapse() async {
    await ref.read(todaysStreakProvider.notifier).resetStreakDueToRelapse();
  }

  /// Start a new temptation
  Future<Temptation> startTemptation({
    String? selectedActivity,
    int? intensityBefore,
  }) async {
    try {
      // Create new temptation
      final newTemptation = Temptation(
        createdAt: DateTime.now(),
        selectedActivity: selectedActivity,
        intensityBefore: intensityBefore,
      );

      // Save to ObjectBox
      final id = await ref
          .read(temptationRepositoryProvider.notifier)
          .createTemptation(newTemptation);

      // Store in SharedPreferences
      await _storageService.storeActiveTemptation(
        temptationId: id,
        startTime: newTemptation.createdAt,
        selectedActivity: selectedActivity,
        intensityBefore: intensityBefore,
      );

      // Refresh state
      ;

      return newTemptation;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// Refresh the provider state
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    ;
  }
}
