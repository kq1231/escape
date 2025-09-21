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

  // History-specific methods

  // Get prayers with pagination
  Future<List<Prayer>> getPrayersWithPagination({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    String? prayerName,
  }) async {
    Condition<Prayer>? condition;

    // Build date range condition
    if (startDate != null && endDate != null) {
      condition = Prayer_.date.betweenDate(startDate, endDate);
    } else if (startDate != null) {
      condition = Prayer_.date.greaterOrEqualDate(startDate);
    } else if (endDate != null) {
      condition = Prayer_.date.lessOrEqualDate(endDate);
    }

    // Add completion filter
    if (isCompleted != null) {
      final completedCondition = Prayer_.isCompleted.equals(isCompleted);
      condition = condition != null
          ? condition.and(completedCondition)
          : completedCondition;
    }

    // Add prayer name filter
    if (prayerName != null) {
      final nameCondition = Prayer_.name.equals(prayerName);
      condition = condition != null
          ? condition.and(nameCondition)
          : nameCondition;
    }

    final query = condition != null
        ? _prayerBox.query(condition)
        : _prayerBox.query();

    final queryBuilt = query
        .order(Prayer_.date, flags: Order.descending)
        .build();

    // Use ObjectBox native pagination for better memory efficiency
    queryBuilt.offset = offset;
    queryBuilt.limit = limit;

    final results = await queryBuilt.findAsync();
    queryBuilt.close();

    return results;
  }

  // Search prayers by criteria
  Future<List<Prayer>> searchPrayers({
    DateTime? startDate,
    DateTime? endDate,
    bool? isCompleted,
    String? prayerName,
    List<String>? prayerNames,
  }) async {
    Condition<Prayer>? condition;

    // Build date range condition
    if (startDate != null && endDate != null) {
      condition = Prayer_.date.betweenDate(startDate, endDate);
    }

    // Add completion filter
    if (isCompleted != null) {
      final completedCondition = Prayer_.isCompleted.equals(isCompleted);
      condition = condition != null
          ? condition.and(completedCondition)
          : completedCondition;
    }

    // Add prayer name filter
    if (prayerName != null) {
      final nameCondition = Prayer_.name.equals(prayerName);
      condition = condition != null
          ? condition.and(nameCondition)
          : nameCondition;
    }

    // Add multiple prayer names filter
    if (prayerNames != null && prayerNames.isNotEmpty) {
      Condition<Prayer>? namesCondition;
      for (final name in prayerNames) {
        final nameCondition = Prayer_.name.equals(name);
        namesCondition = namesCondition != null
            ? namesCondition.or(nameCondition)
            : nameCondition;
      }
      if (namesCondition != null) {
        condition = condition != null
            ? condition.and(namesCondition)
            : namesCondition;
      }
    }

    final query = condition != null
        ? _prayerBox.query(condition)
        : _prayerBox.query();

    final queryBuilt = query
        .order(Prayer_.date, flags: Order.descending)
        .build();

    final result = await queryBuilt.findAsync();
    queryBuilt.close();
    return result;
  }

  // Get prayer statistics for a date range
  Future<Map<String, dynamic>> getPrayerStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prayers = await searchPrayers(startDate: startDate, endDate: endDate);

    if (prayers.isEmpty) {
      return {
        'totalPrayers': 0,
        'completedPrayers': 0,
        'missedPrayers': 0,
        'completionRate': 0.0,
        'prayerBreakdown': <String, Map<String, int>>{},
      };
    }

    final completedPrayers = prayers.where((p) => p.isCompleted).length;
    final missedPrayers = prayers.where((p) => !p.isCompleted).length;

    // Prayer breakdown by name
    final Map<String, Map<String, int>> prayerBreakdown = {};
    for (final prayer in prayers) {
      if (!prayerBreakdown.containsKey(prayer.name)) {
        prayerBreakdown[prayer.name] = {'completed': 0, 'missed': 0};
      }
      if (prayer.isCompleted) {
        prayerBreakdown[prayer.name]!['completed'] =
            (prayerBreakdown[prayer.name]!['completed'] ?? 0) + 1;
      } else {
        prayerBreakdown[prayer.name]!['missed'] =
            (prayerBreakdown[prayer.name]!['missed'] ?? 0) + 1;
      }
    }

    return {
      'totalPrayers': prayers.length,
      'completedPrayers': completedPrayers,
      'missedPrayers': missedPrayers,
      'completionRate': prayers.isNotEmpty
          ? (completedPrayers / prayers.length) * 100
          : 0.0,
      'prayerBreakdown': prayerBreakdown,
    };
  }

  // Get prayers grouped by date
  Future<Map<String, List<Prayer>>> getPrayersGroupedByDate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final prayers = await searchPrayers(startDate: startDate, endDate: endDate);

    final Map<String, List<Prayer>> groupedPrayers = {};

    for (final prayer in prayers) {
      final dateKey =
          '${prayer.date.year}-${prayer.date.month.toString().padLeft(2, '0')}-${prayer.date.day.toString().padLeft(2, '0')}';
      if (!groupedPrayers.containsKey(dateKey)) {
        groupedPrayers[dateKey] = [];
      }
      groupedPrayers[dateKey]!.add(prayer);
    }

    return groupedPrayers;
  }
}
