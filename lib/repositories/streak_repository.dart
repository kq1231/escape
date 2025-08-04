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

  // Get best streak (highest count with latest date)
  Streak? getBestStreak() {
    // Get all streaks sorted by count descending, then by date descending
    final query = _streakBox
        .query()
        .order(Streak_.count, flags: Order.descending)
        .order(Streak_.date, flags: Order.descending)
        .build();
    final result = query.find();
    query.close();

    // Return the first result (highest count, latest date) or null if empty
    return result.isEmpty ? null : result.first;
  }

  // Watch best streak (highest count with latest date)
  Stream<Streak?> watchBestStreak() {
    // Build and watch the query for best streak
    return _streakBox
        .query()
        .order(Streak_.count, flags: Order.descending)
        .order(Streak_.date, flags: Order.descending)
        .watch(triggerImmediately: true)
        // Map it to a single streak object or null
        .asyncMap((query) async {
          final result = await query.findFirstAsync();
          return result;
        });
  }

  // Mark success - increment streak count
  Future<int> markSuccess({required Streak streak}) async {
    final id = _streakBox.put(streak..count = streak.count + 1);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Mark relapse - reset streak to 0
  Future<int> markRelapse({required Streak streak}) async {
    final id = _streakBox.put(streak..count = 0);
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

  // Watch current streak
  Stream<Streak?> watchCurrentStreak() {
    // Build and watch the query for today's streak
    return _streakBox
        .query()
        .order(Streak_.date, flags: Order.descending)
        .watch(triggerImmediately: true)
        // Map it to a single streak object or null
        .asyncMap((query) async {
          final result = await query.findFirstAsync();
          return result;
        });
  }
}
