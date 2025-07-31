import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/streak_model.dart';

part 'streak_repository.g.dart';

@Riverpod(keepAlive: true)
class StreakRepository extends _$StreakRepository {
  late Box<Streak> _streakBox;

  @override
  FutureOr<void> build() async {
    _streakBox = ref.read(objectboxProvider).requireValue.store.box<Streak>();
  }

  // Create a new streak record
  Future<int> createStreak(Streak streak) async {
    final id = _streakBox.put(streak);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Get streak by ID
  Streak? getStreakById(int id) {
    return _streakBox.get(id);
  }

  // Get streak by date
  Streak? getStreakByDate(DateTime date) {
    final query = _streakBox
        .query(Streak_.date.equals(date.millisecondsSinceEpoch ~/ 1000))
        .build();
    final result = query.find();
    query.close();
    return result.isEmpty ? null : result.first;
  }

  // Get today's streak
  Streak? getTodayStreak() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final query = _streakBox
        .query(Streak_.date.betweenDate(startOfDay, endOfDay))
        .build();
    final result = query.find();
    query.close();
    return result.isEmpty ? null : result.first;
  }

  // Update streak
  Future<int> updateStreak(Streak streak) async {
    final id = _streakBox.put(streak);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Delete streak
  Future<bool> deleteStreak(int id) async {
    final result = _streakBox.remove(id);
    // Refresh the state
    ref.invalidateSelf();
    return result;
  }

  // Delete all streaks
  Future<int> deleteAllStreaks() async {
    final count = _streakBox.removeAll();
    // Refresh the state
    ref.invalidateSelf();
    return count;
  }

  // Get streak count
  int getStreakCount() {
    return _streakBox.count();
  }

  // Get current streak (highest consecutive count)
  int getCurrentStreak() {
    // Get all streaks sorted by date descending
    final streaks = _streakBox.getAll()
      ..sort((a, b) => b.date.compareTo(a.date));

    // Find the latest consecutive successful streak
    int currentStreak = 0;
    for (final streak in streaks) {
      if (streak.isSuccess) {
        currentStreak++;
      } else {
        // Break the streak on relapse
        break;
      }
    }
    return currentStreak;
  }

  // Mark success - increment streak count
  Future<int> markSuccess({
    required String emotion,
    required int moodIntensity,
  }) async {
    final DateTime now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Check if there's already a streak record for today
    final query = _streakBox
        .query(Streak_.date.betweenDate(startOfDay, endOfDay))
        .build();
    final result = query.find();
    query.close();

    Streak streak;
    if (result.isEmpty) {
      // No streak record for today, create a new one
      // Get yesterday's streak to determine today's starting count
      final yesterday = DateTime(today.year, today.month, today.day - 1);
      final yesterdayStart = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
      );
      final yesterdayEnd = DateTime(
        yesterday.year,
        yesterday.month,
        yesterday.day,
        23,
        59,
        59,
      );

      final yesterdayQuery = _streakBox
          .query(Streak_.date.betweenDate(yesterdayStart, yesterdayEnd))
          .build();
      final yesterdayResult = yesterdayQuery.find();
      yesterdayQuery.close();

      final yesterdayStreakCount = yesterdayResult.isEmpty
          ? 0
          : yesterdayResult.first.count;

      // Create new streak with incremented count
      streak = Streak(
        count: yesterdayStreakCount + 1,
        goal: 1, // Default goal
        emotion: emotion,
        moodIntensity: moodIntensity,
        isSuccess: true, // Mark as success
        date: today,
      );
    } else {
      // Update existing streak record for today
      final existingStreak = result.first;
      streak = existingStreak.copyWith(
        count: existingStreak.isSuccess
            ? existingStreak.count
            : existingStreak.count + 1, // Only increment if it was a relapse
        emotion: emotion,
        moodIntensity: moodIntensity,
        isSuccess: true, // Mark as success
        lastUpdated: DateTime.now(),
      );
    }

    final id = _streakBox.put(streak);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Mark relapse - reset streak to 0
  Future<int> markRelapse({
    required String emotion,
    required int moodIntensity,
  }) async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Check if there's already a streak record for today
    final query = _streakBox
        .query(Streak_.date.betweenDate(startOfDay, endOfDay))
        .build();
    final result = query.find();
    query.close();

    Streak streak;
    if (result.isEmpty) {
      // No streak record for today, create a new one with count 0
      streak = Streak(
        count: 0,
        goal: 1, // Default goal
        emotion: emotion,
        moodIntensity: moodIntensity,
        isSuccess: false, // Mark as relapse
        date: today,
      );
    } else {
      // Update existing streak record for today
      final existingStreak = result.first;
      streak = existingStreak.copyWith(
        count: 0,
        emotion: emotion,
        moodIntensity: moodIntensity,
        isSuccess: false, // Mark as relapse
        lastUpdated: DateTime.now(),
      );
    }

    final id = _streakBox.put(streak);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Listen to changes in streak data
  Stream<List<Streak>> watchStreaks() {
    // Build and watch the query, set triggerImmediately to emit the query immediately on listen.
    return _streakBox
        .query()
        .watch(triggerImmediately: true)
        // Map it to a list of objects to be used by a StreamBuilder.
        .map((query) => query.find());
  }

  // Watch today's streak
  Stream<Streak?> watchTodaysStreak() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    // Build and watch the query for today's streak
    return _streakBox
        .query(Streak_.date.betweenDate(startOfDay, endOfDay))
        .watch(triggerImmediately: true)
        // Map it to a single streak object or null
        .map((query) {
          final result = query.find();
          return result.isEmpty ? null : result.first;
        });
  }
}
