import 'package:escape/models/streak_model.dart';
import 'package:escape/providers/goal_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/streak_repository.dart';

part 'streak_provider.g.dart';

/// A provider that handles all streak-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@Riverpod(keepAlive: false)
class TodaysStreak extends _$TodaysStreak {
  late int streakGoal;

  @override
  Stream<Streak?> build() async* {
    // Watch the goal
    streakGoal = ref.watch(goalProvider);

    // Watch the streak in DB for today's streak changes
    Stream<Streak?> stream = ref
        .read(streakRepositoryProvider.notifier)
        .watchCurrentStreak();
    yield* stream;
  }

  /// Create a new streak record
  Future<int> createStreak(Streak streak) async {
    return await ref
        .read(streakRepositoryProvider.notifier)
        .createStreak(streak..goal = streakGoal);
  }

  /// Update an existing streak record
  Future<int> updateStreak(Streak streak) async {
    return await ref
        .read(streakRepositoryProvider.notifier)
        .updateStreak(streak..goal = streakGoal);
  }

  /// Delete a streak record by ID
  Future<bool> deleteStreak(int id) async {
    return await ref.read(streakRepositoryProvider.notifier).deleteStreak(id);
  }

  /// Mark success - increment streak count
  Future<void> markSuccess(Streak streak) async {
    await ref
        .read(streakRepositoryProvider.notifier)
        .markSuccess(streak: streak);
  }

  /// Mark relapse - reset streak to 0
  Future<void> markRelapse(Streak streak) async {
    await ref
        .read(streakRepositoryProvider.notifier)
        .markRelapse(streak: streak);
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

  /// Reset streak due to relapse - creates/updates today's streak with count = 0
  Future<void> resetStreakDueToRelapse() async {
    final today = DateTime.now();
    final todayStreak = Streak(
      date: DateTime(today.year, today.month, today.day),
      count: 0, // Reset to zero
      isSuccess: false, // Mark as not clean
      emotion: 'neutral',
      moodIntensity: 0,
    );

    // Upsert operation - update if exists, create if doesn't
    await ref.read(streakRepositoryProvider.notifier).upsertStreak(todayStreak);

    // Invalidate current state to refresh UI
    ref.invalidateSelf();
  }
}
