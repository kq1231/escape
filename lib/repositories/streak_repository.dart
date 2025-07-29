import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/streak_model.dart';

part 'streak_repository.g.dart';

@Riverpod()
class StreakRepository extends _$StreakRepository {
  late final Box<Streak> _streakBox;

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
        .query(
          Streak_.date.between(
            startOfDay.millisecondsSinceEpoch ~/ 1000,
            endOfDay.millisecondsSinceEpoch ~/ 1000,
          ),
        )
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
    // This would need to be implemented based on your specific logic
    // For now, we'll return the count from the latest streak record
    final streaks = _streakBox.getAll()
      ..sort((a, b) => b.date.compareTo(a.date));
    return streaks.isEmpty ? 0 : streaks.first.count;
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
}
