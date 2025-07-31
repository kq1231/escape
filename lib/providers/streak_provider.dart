import 'package:escape/models/streak_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/streak_repository.dart';

part 'streak_provider.g.dart';

/// A provider that handles all streak-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@Riverpod(keepAlive: false)
class TodaysStreak extends _$TodaysStreak {
  @override
  Stream<Streak?> build() async* {
    // Watch the streak in DB for today's streak changes
    Stream<Streak?> stream = ref
        .read(streakRepositoryProvider.notifier)
        .watchTodaysStreak();
    yield* stream;
  }

  /// Create a new streak record
  Future<int> createStreak(Streak streak) async {
    return await ref
        .read(streakRepositoryProvider.notifier)
        .createStreak(streak);
  }

  /// Update an existing streak record
  Future<int> updateStreak(Streak streak) async {
    return await ref
        .read(streakRepositoryProvider.notifier)
        .updateStreak(streak);
  }

  /// Delete a streak record by ID
  Future<bool> deleteStreak(int id) async {
    return await ref.read(streakRepositoryProvider.notifier).deleteStreak(id);
  }

  /// Mark success - increment streak count
  Future<void> markSuccess({
    required String emotion,
    required int moodIntensity,
  }) async {
    await ref
        .read(streakRepositoryProvider.notifier)
        .markSuccess(emotion: emotion, moodIntensity: moodIntensity);
  }

  /// Mark relapse - reset streak to 0
  Future<void> markRelapse({
    required String emotion,
    required int moodIntensity,
  }) async {
    await ref
        .read(streakRepositoryProvider.notifier)
        .markRelapse(emotion: emotion, moodIntensity: moodIntensity);
  }

  /// Update streak goal
  Future<int> updateGoal(Streak streak, int newGoal) async {
    final updatedStreak = streak.copyWith(
      goal: newGoal,
      lastUpdated: DateTime.now(),
    );
    return await ref
        .read(streakRepositoryProvider.notifier)
        .updateStreak(updatedStreak);
  }

  /// Get today's streak
  Streak? getTodaysStreak() {
    return ref.read(streakRepositoryProvider.notifier).getTodayStreak();
  }

  /// Get streak by ID
  Streak? getStreakById(int id) {
    return ref.read(streakRepositoryProvider.notifier).getStreakById(id);
  }

  /// Get current streak count
  int getCurrentStreak() {
    return ref.read(streakRepositoryProvider.notifier).getCurrentStreak();
  }
}
