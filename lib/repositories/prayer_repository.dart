import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/prayer_model.dart';

part 'prayer_repository.g.dart';

@Riverpod(keepAlive: true)
class PrayerRepository extends _$PrayerRepository {
  late Box<Prayer> _prayerBox;

  @override
  FutureOr<void> build() async {
    _prayerBox = ref.read(objectboxProvider).requireValue.store.box<Prayer>();
  }

  // Create a new prayer record
  Future<int> createPrayer(Prayer prayer) async {
    final id = _prayerBox.put(prayer);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Get prayer by ID
  Prayer? getPrayerById(int id) {
    return _prayerBox.get(id);
  }

  // Get prayers by date
  List<Prayer> getPrayersByDate(DateTime date) {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final query = _prayerBox
        .query(Prayer_.date.betweenDate(startOfDay, endOfDay))
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get today's prayers
  List<Prayer> getTodayPrayers() {
    final today = DateTime.now();
    return getPrayersByDate(today);
  }

  // Update prayer
  Future<int> updatePrayer(Prayer prayer) async {
    final id = _prayerBox.put(prayer);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Delete prayer
  Future<bool> deletePrayer(int id) async {
    final result = _prayerBox.remove(id);
    // Refresh the state
    ref.invalidateSelf();
    return result;
  }

  // Delete all prayers
  Future<int> deleteAllPrayers() async {
    final count = _prayerBox.removeAll();
    // Refresh the state
    ref.invalidateSelf();
    return count;
  }

  // Get prayer count
  int getPrayerCount() {
    return _prayerBox.count();
  }

  // Get completed prayer count
  int getCompletedPrayerCount() {
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
  int getTodayCompletedPrayerCount() {
    final todayPrayers = getTodayPrayers();
    return todayPrayers.where((prayer) => prayer.isCompleted).length;
  }

  // Get completed prayer count for a specific date
  int getCompletedPrayerCountByDate(DateTime date) {
    final prayers = getPrayersByDate(date);
    return prayers.where((prayer) => prayer.isCompleted).length;
  }

  // Toggle prayer completion status
  Future<void> togglePrayerCompletion(int prayerId) async {
    final prayer = getPrayerById(prayerId);
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
        .map((query) => query.find());
  }
}
