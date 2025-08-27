import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/streak_model.dart';

part 'streak_repository.g.dart';

@Riverpod(keepAlive: false)
class StreakRepository extends _$StreakRepository {
  late Box<Streak> _streakBox;

  @override
  FutureOr<void> build() async {
    _streakBox = ref.read(objectboxProvider).requireValue.store.box<Streak>();
  }

  // Create a new streak record
  Future<int> createStreak(Streak streak) async {
    // Make sure the date only contains year, month and day
    DateTime date = DateTime(
      streak.date.year,
      streak.date.month,
      streak.date.day,
    );

    streak.date = date;

    final id = await _streakBox.putAsync(streak);
    return id;
  }

  // Get streak by ID
  Future<Streak?> getStreakById(int id) async {
    return await _streakBox.getAsync(id);
  }

  // Get streak by date
  Future<Streak?> getStreakByDate(DateTime date) async {
    final query = _streakBox.query(Streak_.date.equalsDate(date)).build();
    final result = await query.findFirstAsync();
    query.close();
    return result;
  }

  // Get today's streak
  Future<Streak?> getTodaysStreak() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    final query = _streakBox.query(Streak_.date.equalsDate(today)).build();
    final result = await query.findAsync();
    query.close();
    return result.isEmpty ? null : result.first;
  }

  // Update streak
  Future<int> updateStreak(Streak streak) async {
    // Make sure the date only contains year, month and day
    DateTime date = DateTime(
      streak.date.year,
      streak.date.month,
      streak.date.day,
    );

    streak.date = date;

    final id = await _streakBox.putAsync(streak);
    return id;
  }

  // Delete streak
  Future<bool> deleteStreak(int id) async {
    final result = await _streakBox.removeAsync(id);
    return result;
  }

  // Delete all streaks
  Future<int> deleteAllStreaks() async {
    final count = await _streakBox.removeAllAsync();
    return count;
  }

  // Get streak count
  Future<int> getStreakCount() async {
    final query = _streakBox.query().build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get current streak (highest consecutive count)
  Future<Streak?> getCurrentStreak() async {
    final query = _streakBox
        .query()
        .order(Streak_.date, flags: Order.descending)
        .build();

    final result = await query.findFirstAsync();
    query.close();
    return result;
  }

  // Get best streak (highest count with latest date)
  Future<Streak?> getBestStreak() async {
    // Get all streaks sorted by count descending, then by date descending
    final query = _streakBox
        .query()
        .order(Streak_.count, flags: Order.descending)
        .order(Streak_.date, flags: Order.descending)
        .build();
    final result = await query.findAsync();
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
    // Make sure the date only contains year, month and day
    DateTime date = DateTime(
      streak.date.year,
      streak.date.month,
      streak.date.day,
    );

    streak.date = date;

    final id = await _streakBox.putAsync(
      streak
        ..count = streak.count + 1
        ..isSuccess = true,
    );
    return id;
  }

  // Mark relapse - reset streak to 0
  Future<int> markRelapse({required Streak streak}) async {
    // Make sure the date only contains year, month and day
    DateTime date = DateTime(
      streak.date.year,
      streak.date.month,
      streak.date.day,
    );

    streak.date = date;

    final id = await _streakBox.putAsync(
      streak
        ..count = 0
        ..isSuccess = false,
    );
    return id;
  }

  // Listen to changes in streak data
  Stream<List<Streak>> watchStreaks() {
    // Build and watch the query, set triggerImmediately to emit the query immediately on listen.
    return _streakBox
        .query()
        .watch(triggerImmediately: true)
        // Map it to a list of objects to be used by a StreamBuilder.
        .asyncMap((query) async => await query.findAsync());
  }

  // Watch latest streak
  Stream<Streak?> watchLatestStreak() {
    // Build and watch the query for the LATEST/LAST streak
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

  // Watch today's streak
  Stream<Streak?> watchTodaysStreak() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    // Build and watch the query for the LATEST/LAST streak
    return _streakBox
        .query(Streak_.date.equalsDate(today))
        .watch(triggerImmediately: true)
        // Map it to a single streak object or null
        .asyncMap((query) async {
          final result = await query.findFirstAsync();
          return result;
        });
  }

  // Upsert operation - update if exists, create if doesn't
  Future<int> upsertStreakCountAndSuccess(Streak streak) async {
    // Check if streak exists for this date
    final existing = await getStreakByDate(streak.date);

    if (existing != null) {
      // Update existing
      final updatedStreak = existing.copyWith(
        count: streak.count,
        isSuccess: streak.isSuccess,
        lastUpdated: DateTime.now(),
      );

      return await updateStreak(updatedStreak);
    } else {
      // Create new
      return await createStreak(streak);
    }
  }
}
