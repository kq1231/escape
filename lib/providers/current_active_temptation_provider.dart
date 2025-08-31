import 'package:escape/models/temptation_model.dart';
import 'package:escape/features/temptation/services/temptation_storage_service.dart';
import 'package:escape/repositories/temptation_repository.dart';
import 'package:escape/providers/streak_provider.dart';
import 'package:escape/providers/has_active_temptation_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'current_active_temptation_provider.g.dart';

/// Provider for the current active temptation (if any)
/// Used in the temptation flow screen to manage temptation state
///  because it's only used during active temptation sessions
@Riverpod()
class CurrentActiveTemptation extends _$CurrentActiveTemptation {
  late TemptationStorageService _storageService;

  @override
  Future<Temptation?> build() async {
    // Initialize the storage service in case it is not already initialized
    _storageService = TemptationStorageService();
    await _storageService.initialize();
    // Fetch active temptation from SharedPreferences
    return await _fetchActiveTemptation();
  }

  /// Fetch active temptation from SharedPreferences and create Temptation object
  Future<Temptation?> _fetchActiveTemptation() async {
    final temptationId = _storageService.getActiveTemptationId();
    if (temptationId == null) return null;

    // Get the full temptation from ObjectBox
    return await ref
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

      // Invalidate hasActiveTemptation provider
      if (ref.mounted) {
        ref.invalidate(hasActiveTemptationProvider);
      }

      // Update local state to null since temptation is completed
      if (ref.mounted) {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      // Only set error state if the ref is still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      } else {
        // If ref is disposed, we can't update state, so just rethrow
        rethrow;
      }
    }
  }

  /// Cancel temptation (remove data from shared prefs without saving to ObjectBox)
  Future<void> cancelTemptation() async {
    try {
      // Clear active temptation from SharedPreferences
      await _storageService.clearActiveTemptation();

      // Invalidate hasActiveTemptation provider
      if (ref.mounted) {
        ref.invalidate(hasActiveTemptationProvider);
      }

      // Update local state to null since temptation is cancelled
      if (ref.mounted) {
        state = const AsyncValue.data(null);
      }
    } catch (e, st) {
      // Only set error state if the ref is still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      } else {
        // If ref is disposed, we can't update state, so just rethrow
        rethrow;
      }
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

      // Create temptation with the generated ID
      final temptationWithId = newTemptation.copyWith(id: id);

      // Store in SharedPreferences
      await _storageService.storeActiveTemptation(
        temptationId: id,
        startTime: newTemptation.createdAt,
        selectedActivity: selectedActivity,
        intensityBefore: intensityBefore,
      );

      // Update state with the new temptation
      if (ref.mounted) {
        state = AsyncValue.data(temptationWithId);
      }

      // Invalidate hasActiveTemptation provider
      if (ref.mounted) {
        ref.invalidate(hasActiveTemptationProvider);
      }

      return temptationWithId;
    } catch (e, st) {
      // Only set error state if the ref is still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      }
      rethrow;
    }
  }

  /// Update temptation with new data (e.g., selected activity)
  Future<void> updateTemptation(Temptation updatedTemptation) async {
    try {
      // Update in ObjectBox
      await ref
          .read(temptationRepositoryProvider.notifier)
          .updateTemptation(updatedTemptation);

      // Update in SharedPreferences
      await _storageService.storeActiveTemptation(
        temptationId: updatedTemptation.id,
        startTime: updatedTemptation.createdAt,
        selectedActivity: updatedTemptation.selectedActivity,
        intensityBefore: updatedTemptation.intensityBefore,
      );

      // Update local state
      if (ref.mounted) {
        state = AsyncValue.data(updatedTemptation);
      }
    } catch (e, st) {
      // Only set error state if the ref is still mounted
      if (ref.mounted) {
        state = AsyncValue.error(e, st);
      } else {
        // If ref is disposed, we can't update state, so just rethrow
        rethrow;
      }
    }
  }

  /// Refresh the provider state
  Future<void> refresh() async {
    if (ref.mounted) {
      state = const AsyncValue.loading();
      try {
        final temptation = await _fetchActiveTemptation();
        if (ref.mounted) {
          state = AsyncValue.data(temptation);
        }
      } catch (e, st) {
        if (ref.mounted) {
          state = AsyncValue.error(e, st);
        }
      }
    }
  }
}
