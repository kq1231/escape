import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/prayer_model.dart';

part 'prayer_repository.g.dart';

@Riverpod()
class PrayerRepository extends _$PrayerRepository {
  late Box<Prayer> _prayerBox;

  @override
  FutureOr<void> build() async {
    _prayerBox = ref.read(objectboxProvider).requireValue.store.box<Prayer>();
  }

  // Create a new prayer record
  Future<int> createPrayer(Prayer prayer) async {
    final id = await _prayerBox.putAsync(prayer);
    return id;
  }

  // Get prayer by ID
  Future<Prayer?> getPrayerById(int id) async {
    return await _prayerBox.getAsync(id);
  }

  // Get prayers by date
  Future<List<Prayer>> getPrayersByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final query = _prayerBox
        .query(Prayer_.date.betweenDate(startOfDay, endOfDay))
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  // Get today's prayers
  Future<List<Prayer>> getTodayPrayers() async {
    final today = DateTime.now();
    return await getPrayersByDate(today);
  }

  // Update prayer
  Future<int> updatePrayer(Prayer prayer) async {
    final id = await _prayerBox.putAsync(prayer);
    return id;
  }

  // Delete prayer
  Future<bool> deletePrayer(int id) async {
    final result = await _prayerBox.removeAsync(id);
    return result;
  }

  // Delete all prayers
  Future<int> deleteAllPrayers() async {
    final count = await _prayerBox.removeAllAsync();
    return count;
  }

  // Get prayer count
  Future<int> getPrayerCount() async {
    final query = _prayerBox.query().build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get completed prayer count
  Future<int> getCompletedPrayerCount() async {
    final query = _prayerBox.query(Prayer_.isCompleted.equals(true)).build();
    final count = query.count();
    query.close();
    return count;
  }

  // Watch completed prayer count
  Stream<int> watchCompletedPrayerCount() {
    // Build and watch the query for completed prayers
    return _prayerBox
        .query(Prayer_.isCompleted.equals(true))
        .watch(triggerImmediately: true)
        // Map it to a count
        .map((query) {
          final count = query.count();
          return count;
        });
  }

  // Get completed prayer count for today
  Future<int> getTodayCompletedPrayerCount() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final query = _prayerBox
        .query(
          Prayer_.date
              .betweenDate(startOfDay, endOfDay)
              .and(Prayer_.isCompleted.equals(true)),
        )
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get completed prayer count for a specific date
  Future<int> getCompletedPrayerCountByDate(DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final query = _prayerBox
        .query(
          Prayer_.date
              .betweenDate(startOfDay, endOfDay)
              .and(Prayer_.isCompleted.equals(true)),
        )
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Toggle prayer completion status
  Future<void> togglePrayerCompletion(int prayerId) async {
    final prayer = await getPrayerById(prayerId);
    if (prayer != null) {
      final updatedPrayer = prayer.copyWith(isCompleted: !prayer.isCompleted);
      await updatePrayer(updatedPrayer);
    }
  }

  // Listen to changes in prayer data
  Stream<List<Prayer>> watchPrayers() {
    DateTime now = DateTime.now();
    // Build and watch the query, set triggerImmediately to emit the query immediately on listen.
    return _prayerBox
        .query(
          Prayer_.date.betweenDate(
            DateTime(now.year, now.month, now.day, 0, 0),
            DateTime(now.year, now.month, now.day, 23, 59, 59),
          ),
        )
        .watch(triggerImmediately: true)
        // Map it to a list of objects to be used by a StreamBuilder.
        .asyncMap((query) async => await query.findAsync());
  }
}
