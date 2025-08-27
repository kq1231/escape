import 'dart:async';
import 'package:escape/models/xp_history_item_model.dart';
import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:escape/models/streak_model.dart';
import 'package:escape/models/prayer_model.dart';
import 'package:escape/models/temptation.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_repository.g.dart';

@Riverpod(keepAlive: false)
class AnalyticsRepository extends _$AnalyticsRepository {
  late Box<Streak> _streakBox;
  late Box<Prayer> _prayerBox;
  late Box<Temptation> _temptationBox;
  late Box<XPHistoryItem> _xPHistoryBox;

  @override
  FutureOr<void> build() async {
    final objectbox = ref.read(objectboxProvider).requireValue;
    _streakBox = objectbox.store.box<Streak>();
    _prayerBox = objectbox.store.box<Prayer>();
    _temptationBox = objectbox.store.box<Temptation>();
    _xPHistoryBox = objectbox.store.box<XPHistoryItem>();
  }

  /// Helper method to get date range for analytics
  AnalyticsTimeRange _getTimeRange(AnalyticsTimeRange? range) {
    return range ?? AnalyticsTimeRange.lastDays(30);
  }

  /// Streak Analytics Methods

  /// Get streak contribution grid data (GitHub-style activity grid)
  Future<List<StreakGridData>> getStreakGridData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get data from database (keep this on main thread)
    final query = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();
    final streaks = await query.findAsync();
    query.close();

    final maxStreakQuery = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();
    final maxStreak = maxStreakQuery.property(Streak_.count).max();
    maxStreakQuery.close();

    // Move heavy processing to isolate
    final processingData = {
      'streaks': streaks
          .map(
            (s) => {
              'date': s.date.millisecondsSinceEpoch,
              'count': s.count,
              'isSuccess': s.isSuccess,
            },
          )
          .toList(),
      'timeRangeStart': timeRange.start.millisecondsSinceEpoch,
      'timeRangeEnd': timeRange.end.millisecondsSinceEpoch,
      'maxStreak': maxStreak,
    };

    return await compute(_processStreakDataInIsolate, processingData);
  }

  /// Process streak data in isolate to prevent UI freezing
  static List<StreakGridData> _processStreakDataInIsolate(
    Map<String, dynamic> data,
  ) {
    final streaks = (data['streaks'] as List)
        .map(
          (s) => {
            'date': DateTime.fromMillisecondsSinceEpoch(s['date']),
            'count': s['count'],
            'isSuccess': s['isSuccess'],
          },
        )
        .toList();

    final timeRangeStart = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeStart'],
    );
    final timeRangeEnd = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeEnd'],
    );
    final maxStreak = data['maxStreak'];

    // Create streak map
    final streakMap = <DateTime, Map<String, dynamic>>{};
    for (final streak in streaks) {
      final date = DateTime(
        streak['date'].year,
        streak['date'].month,
        streak['date'].day,
      );
      streakMap[date] = streak;
    }

    // Generate grid data
    final gridData = <StreakGridData>[];
    final totalDays = timeRangeEnd.difference(timeRangeStart).inDays + 1;

    for (int i = 0; i < totalDays; i++) {
      final date = timeRangeStart.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);
      final streak = streakMap[normalizedDate];

      final hasRelapse = streak != null && !(streak['isSuccess'] as bool);
      final streakCount = streak?['count'] as int? ?? 0;
      final intensity = maxStreak > 0 ? streakCount / maxStreak : 0.0;

      gridData.add(
        StreakGridData(
          date: normalizedDate,
          streakCount: streakCount,
          hasRelapse: hasRelapse,
          intensity: intensity,
        ),
      );
    }

    return gridData;
  }

  /// Get prayer completion grid data
  Future<List<PrayerGridData>> getPrayerGridData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get data from database
    final query = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();
    final prayers = await query.findAsync();
    query.close();

    // Move heavy processing to isolate
    final processingData = {
      'prayers': prayers
          .map(
            (p) => {
              'date': p.date.millisecondsSinceEpoch,
              'isCompleted': p.isCompleted,
            },
          )
          .toList(),
      'timeRangeStart': timeRange.start.millisecondsSinceEpoch,
      'timeRangeEnd': timeRange.end.millisecondsSinceEpoch,
    };

    return await compute(_processPrayerDataInIsolate, processingData);
  }

  /// Process prayer data in isolate
  static List<PrayerGridData> _processPrayerDataInIsolate(
    Map<String, dynamic> data,
  ) {
    final prayers = (data['prayers'] as List)
        .map(
          (p) => {
            'date': DateTime.fromMillisecondsSinceEpoch(p['date']),
            'isCompleted': p['isCompleted'],
          },
        )
        .toList();

    final timeRangeStart = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeStart'],
    );
    final timeRangeEnd = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeEnd'],
    );

    // Create prayer map
    final prayerMap = <DateTime, List<Map<String, dynamic>>>{};
    for (final prayer in prayers) {
      final date = DateTime(
        prayer['date'].year,
        prayer['date'].month,
        prayer['date'].day,
      );
      prayerMap.putIfAbsent(date, () => []).add(prayer);
    }

    // Generate grid data
    final gridData = <PrayerGridData>[];
    const maxPrayers = 6;
    final totalDays = timeRangeEnd.difference(timeRangeStart).inDays + 1;

    for (int i = 0; i < totalDays; i++) {
      final date = timeRangeStart.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final dayPrayers = prayerMap[normalizedDate] ?? [];
      final prayersCompleted = dayPrayers
          .where((p) => p['isCompleted'] as bool)
          .length;
      final intensity = prayersCompleted / maxPrayers;

      gridData.add(
        PrayerGridData(
          date: normalizedDate,
          prayersCompleted: prayersCompleted,
          intensity: intensity,
        ),
      );
    }

    return gridData;
  }

  /// Get temptation bar chart data (stacked bar chart)
  Future<List<TemptationBarData>> getTemptationBarData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get data from database
    final query = _temptationBox
        .query(
          Temptation_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();
    final temptations = await query.findAsync();
    query.close();

    // Move heavy processing to isolate
    final processingData = {
      'temptations': temptations
          .map(
            (t) => {
              'createdAt': t.createdAt.millisecondsSinceEpoch,
              'wasSuccessful': t.wasSuccessful,
            },
          )
          .toList(),
      'timeRangeStart': timeRange.start.millisecondsSinceEpoch,
      'timeRangeEnd': timeRange.end.millisecondsSinceEpoch,
    };

    return await compute(_processTemptationDataInIsolate, processingData);
  }

  /// Process temptation data in isolate
  static List<TemptationBarData> _processTemptationDataInIsolate(
    Map<String, dynamic> data,
  ) {
    final temptations = (data['temptations'] as List)
        .map(
          (t) => {
            'createdAt': DateTime.fromMillisecondsSinceEpoch(t['createdAt']),
            'wasSuccessful': t['wasSuccessful'],
          },
        )
        .toList();

    final timeRangeStart = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeStart'],
    );
    final timeRangeEnd = DateTime.fromMillisecondsSinceEpoch(
      data['timeRangeEnd'],
    );

    // Create temptation map
    final temptationMap = <DateTime, List<Map<String, dynamic>>>{};
    for (final temptation in temptations) {
      final date = DateTime(
        temptation['createdAt'].year,
        temptation['createdAt'].month,
        temptation['createdAt'].day,
      );
      temptationMap.putIfAbsent(date, () => []).add(temptation);
    }

    // Generate bar data
    final barData = <TemptationBarData>[];
    final totalDays = timeRangeEnd.difference(timeRangeStart).inDays + 1;

    for (int i = 0; i < totalDays; i++) {
      final date = timeRangeStart.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final dayTemptations = temptationMap[normalizedDate] ?? [];
      final successfulCount = dayTemptations
          .where((t) => t['wasSuccessful'] as bool)
          .length;
      final relapseCount = dayTemptations
          .where((t) => !(t['wasSuccessful'] as bool))
          .length;

      barData.add(
        TemptationBarData(
          date: normalizedDate,
          successfulCount: successfulCount,
          relapseCount: relapseCount,
        ),
      );
    }

    return barData;
  }

  /// Get XP growth data for line chart (cumulative and daily)
  Future<List<XPGrowthData>> getXPGrowthData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get data from database
    final query = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .order(XPHistoryItem_.createdAt)
        .build();
    final xpItems = await query.findAsync();
    query.close();

    if (xpItems.isEmpty) {
      return [];
    }

    // Move heavy processing to isolate
    final processingData = {
      'xpItems': xpItems
          .map(
            (item) => {
              'createdAt': item.createdAt.millisecondsSinceEpoch,
              'amount': item.amount,
            },
          )
          .toList(),
    };

    return await compute(_processXPGrowthDataInIsolate, processingData);
  }

  /// Process XP growth data in isolate
  static List<XPGrowthData> _processXPGrowthDataInIsolate(
    Map<String, dynamic> data,
  ) {
    final xpItems = (data['xpItems'] as List)
        .map(
          (item) => {
            'createdAt': DateTime.fromMillisecondsSinceEpoch(item['createdAt']),
            'amount': item['amount'],
          },
        )
        .toList();

    // Group XP items by day
    final dailyXPMap = <DateTime, int>{};
    for (final item in xpItems) {
      final date = DateTime(
        item['createdAt'].year,
        item['createdAt'].month,
        item['createdAt'].day,
      );
      dailyXPMap[date] = (dailyXPMap[date] ?? 0) + (item['amount'] as int);
    }

    // Generate growth data with cumulative calculation
    final growthData = <XPGrowthData>[];
    int cumulativeXP = 0;

    final sortedDates = dailyXPMap.keys.toList()..sort();
    for (final date in sortedDates) {
      final dailyXP = dailyXPMap[date]!;
      cumulativeXP += dailyXP;

      growthData.add(
        XPGrowthData(date: date, cumulativeXP: cumulativeXP, dailyXP: dailyXP),
      );
    }

    return growthData;
  }

  /// Get XP source breakdown for pie chart
  Future<List<XPSourceData>> getXPSourceBreakdown({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get data from database
    final query = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();
    final xpItems = await query.findAsync();
    query.close();

    // Move heavy processing to isolate
    final processingData = {
      'xpItems': xpItems
          .map(
            (item) => {'amount': item.amount, 'description': item.description},
          )
          .toList(),
    };

    return await compute(_processXPSourceDataInIsolate, processingData);
  }

  /// Process XP source data in isolate
  static List<XPSourceData> _processXPSourceDataInIsolate(
    Map<String, dynamic> data,
  ) {
    final xpItems = data['xpItems'] as List;

    final sourceMap = <String, int>{};
    final colors = <String, Color>{
      'Prayer': Colors.blue,
      'Streak': Colors.orange,
      'Temptation': Colors.green,
      'Challenges': Colors.purple,
      'Media': Colors.teal,
      'Other': Colors.grey,
    };

    for (final item in xpItems) {
      // Extract source from description
      String source = 'Other';
      final desc = (item['description'] as String).toLowerCase();

      if (desc.contains('prayer')) {
        source = 'Prayer';
      } else if (desc.contains('streak') || desc.contains('clean')) {
        source = 'Streak';
      } else if (desc.contains('temptation') || desc.contains('tawbah')) {
        source = 'Temptation';
      } else if (desc.contains('challenge')) {
        source = 'Challenges';
      } else if (desc.contains('media') ||
          desc.contains('article') ||
          desc.contains('video')) {
        source = 'Media';
      }

      sourceMap[source] = (sourceMap[source] ?? 0) + (item['amount'] as int);
    }

    // Convert to XPSourceData with colors
    return sourceMap.entries.map((entry) {
      return XPSourceData(
        source: entry.key,
        xpAmount: entry.value,
        color: colors[entry.key] ?? Colors.grey,
      );
    }).toList();
  }

  // Keep the remaining methods that don't need isolates (they're already efficient)

  /// Get streak progress data for line chart
  Future<List<Map<String, dynamic>>> getStreakProgressData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    final query = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .order(Streak_.date)
        .build();

    final streaks = await query.findAsync();
    query.close();

    return streaks
        .map(
          (streak) => {
            'date': streak.date,
            'count': streak.count,
            'isSuccess': streak.isSuccess,
          },
        )
        .toList();
  }

  /// Get streak statistics
  Future<StreakStatistics> getStreakStatistics({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Use ObjectBox aggregate functions for efficient calculations
    final baseQuery = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final totalDays = baseQuery.count();
    baseQuery.close();

    if (totalDays == 0) {
      return StreakStatistics(
        currentStreak: 0,
        longestStreak: 0,
        totalDays: 0,
        successRate: 0.0,
        monthlyStats: AnalyticsStatistics(
          total: 0,
          current: 0,
          best: 0,
          successRate: 0.0,
        ),
      );
    }

    final longestStreakQuery = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();
    final longestStreak = longestStreakQuery.property(Streak_.count).max();
    longestStreakQuery.close();

    final successfulQuery = _streakBox
        .query(
          Streak_.date
              .betweenDate(timeRange.start, timeRange.end)
              .and(Streak_.isSuccess.equals(true)),
        )
        .build();
    final successfulDays = successfulQuery.count();
    final currentStreak = successfulQuery.property(Streak_.count).max();
    successfulQuery.close();

    final successRate = totalDays > 0 ? successfulDays / totalDays : 0.0;
    final monthlyStats = await _getMonthlyStreakStatistics();

    return StreakStatistics(
      currentStreak: currentStreak,
      longestStreak: longestStreak,
      totalDays: totalDays,
      successRate: successRate,
      monthlyStats: monthlyStats,
    );
  }

  /// Get monthly streak statistics for comparison
  Future<AnalyticsStatistics> _getMonthlyStreakStatistics() async {
    final now = DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1);
    final endOfMonth = DateTime(now.year, now.month + 1, 0);

    // Use ObjectBox aggregate functions for efficient calculations
    final totalQuery = _streakBox
        .query(Streak_.date.betweenDate(startOfMonth, endOfMonth))
        .build();
    final total = totalQuery.count();
    totalQuery.close();

    if (total == 0) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    // Get best streak using aggregate function
    final bestQuery = _streakBox
        .query(Streak_.date.betweenDate(startOfMonth, endOfMonth))
        .build();
    final bestStreak = bestQuery.property(Streak_.count).max();
    bestQuery.close();

    // Get successful days count
    final successfulQuery = _streakBox
        .query(
          Streak_.date
              .betweenDate(startOfMonth, endOfMonth)
              .and(Streak_.isSuccess.equals(true)),
        )
        .build();
    final successfulDays = successfulQuery.count();
    successfulQuery.close();

    // Get current (latest) streak - need to fetch the most recent record
    final currentQuery = _streakBox
        .query(Streak_.date.betweenDate(startOfMonth, endOfMonth))
        .order(Streak_.date, flags: Order.descending)
        .build();
    final latestStreak = await currentQuery.findFirstAsync();
    currentQuery.close();

    final successRate = total > 0 ? successfulDays / total : 0.0;

    return AnalyticsStatistics(
      total: total,
      current: latestStreak?.count ?? 0,
      best: bestStreak,
      successRate: successRate,
    );
  }

  /// Prayer Analytics Methods

  /// Get prayer completion breakdown by prayer type
  Future<Map<String, int>> getPrayerBreakdown({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    final query = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final prayers = await query.findAsync();
    query.close();

    final breakdown = <String, int>{
      'Fajr': 0,
      'Dhuhr': 0,
      'Asr': 0,
      'Maghrib': 0,
      'Isha': 0,
      'Tahajjud': 0,
    };

    for (final prayer in prayers) {
      if (prayer.isCompleted && breakdown.containsKey(prayer.name)) {
        breakdown[prayer.name] = (breakdown[prayer.name] ?? 0) + 1;
      }
    }

    return breakdown;
  }

  /// Get prayer statistics
  Future<PrayerStatistics> getPrayerStatistics({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Use ObjectBox aggregate functions for efficient calculations
    final totalQuery = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();
    final totalPrayers = totalQuery.count();
    totalQuery.close();

    if (totalPrayers == 0) {
      return PrayerStatistics(
        totalPrayers: 0,
        completedPrayers: 0,
        completionRate: 0.0,
        prayerBreakdown: {},
        weeklyStats: AnalyticsStatistics(
          total: 0,
          current: 0,
          best: 0,
          successRate: 0.0,
        ),
      );
    }

    // Get completed prayers count efficiently
    final completedQuery = _prayerBox
        .query(
          Prayer_.date
              .betweenDate(timeRange.start, timeRange.end)
              .and(Prayer_.isCompleted.equals(true)),
        )
        .build();
    final completedPrayers = completedQuery.count();
    completedQuery.close();

    final completionRate = totalPrayers > 0
        ? completedPrayers / totalPrayers
        : 0.0;
    final breakdown = await getPrayerBreakdown(range: timeRange);

    // Get weekly statistics for comparison
    final weeklyStats = await _getWeeklyPrayerStatistics();

    return PrayerStatistics(
      totalPrayers: totalPrayers,
      completedPrayers: completedPrayers,
      completionRate: completionRate,
      prayerBreakdown: breakdown,
      weeklyStats: weeklyStats,
    );
  }

  /// Get weekly prayer statistics for comparison
  Future<AnalyticsStatistics> _getWeeklyPrayerStatistics() async {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Use ObjectBox aggregate functions for efficient calculations
    final totalQuery = _prayerBox
        .query(Prayer_.date.betweenDate(startOfWeek, endOfWeek))
        .build();
    final total = totalQuery.count();
    totalQuery.close();

    if (total == 0) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    // Get completed prayers count efficiently
    final completedQuery = _prayerBox
        .query(
          Prayer_.date
              .betweenDate(startOfWeek, endOfWeek)
              .and(Prayer_.isCompleted.equals(true)),
        )
        .build();
    final completedPrayers = completedQuery.count();
    completedQuery.close();

    final completionRate = total > 0 ? completedPrayers / total : 0.0;

    return AnalyticsStatistics(
      total: total,
      current: completedPrayers,
      best: completedPrayers, // For prayers, best is the completion count
      successRate: completionRate,
    );
  }

  /// Temptation Analytics Methods

  /// Get temptation statistics
  Future<TemptationStatistics> getTemptationStatistics({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Use ObjectBox aggregate functions for efficient calculations
    final totalQuery = _temptationBox
        .query(
          Temptation_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();
    final totalTemptations = totalQuery.count();
    totalQuery.close();

    if (totalTemptations == 0) {
      return TemptationStatistics(
        totalTemptations: 0,
        successfulTemptations: 0,
        relapses: 0,
        successRate: 0.0,
        weeklyStats: AnalyticsStatistics(
          total: 0,
          current: 0,
          best: 0,
          successRate: 0.0,
        ),
      );
    }

    // Get successful temptations count efficiently
    final successfulQuery = _temptationBox
        .query(
          Temptation_.createdAt
              .betweenDate(timeRange.start, timeRange.end)
              .and(Temptation_.wasSuccessful.equals(true)),
        )
        .build();
    final successfulTemptations = successfulQuery.count();
    successfulQuery.close();

    final relapses = totalTemptations - successfulTemptations;
    final successRate = totalTemptations > 0
        ? successfulTemptations / totalTemptations
        : 0.0;

    // Get weekly statistics for comparison
    final weeklyStats = await _getWeeklyTemptationStatistics();

    return TemptationStatistics(
      totalTemptations: totalTemptations,
      successfulTemptations: successfulTemptations,
      relapses: relapses,
      successRate: successRate,
      weeklyStats: weeklyStats,
    );
  }

  /// Get weekly temptation statistics for comparison
  Future<AnalyticsStatistics> _getWeeklyTemptationStatistics() async {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Use ObjectBox aggregate functions for efficient calculations
    final totalQuery = _temptationBox
        .query(Temptation_.createdAt.betweenDate(startOfWeek, endOfWeek))
        .build();
    final total = totalQuery.count();
    totalQuery.close();

    if (total == 0) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    // Get successful temptations count efficiently
    final successfulQuery = _temptationBox
        .query(
          Temptation_.createdAt
              .betweenDate(startOfWeek, endOfWeek)
              .and(Temptation_.wasSuccessful.equals(true)),
        )
        .build();
    final successfulTemptations = successfulQuery.count();
    successfulQuery.close();

    final successRate = total > 0 ? successfulTemptations / total : 0.0;

    return AnalyticsStatistics(
      total: total,
      current: successfulTemptations,
      best: successfulTemptations, // For temptations, best is the success count
      successRate: successRate,
    );
  }

  /// XP Analytics Methods
  /// Get XP statistics
  Future<XPStatistics> getXPStatistics({AnalyticsTimeRange? range}) async {
    final timeRange = _getTimeRange(range);

    // Use ObjectBox aggregate functions for efficient calculations
    final baseQuery = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();

    // Get total count to check if empty
    final totalCount = baseQuery.count();
    if (totalCount == 0) {
      baseQuery.close();
      return XPStatistics(
        totalXP: 0,
        currentXP: 0,
        averageDailyXP: 0,
        bestSingleDay: 0,
        weeklyStats: AnalyticsStatistics(
          total: 0,
          current: 0,
          best: 0,
          successRate: 0.0,
        ),
      );
    }

    // Use aggregate functions for efficient calculations
    final totalXP = baseQuery.property(XPHistoryItem_.amount).sum();
    final bestSingleDay = baseQuery.property(XPHistoryItem_.amount).max();
    baseQuery.close();

    // For average daily XP, we need to get unique days - this requires fetching data
    // but only the dates, not full objects
    final daysQuery = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();
    final xpItems = await daysQuery.findAsync();
    daysQuery.close();

    final daysWithData = xpItems
        .map(
          (item) => DateTime(
            item.createdAt.year,
            item.createdAt.month,
            item.createdAt.day,
          ),
        )
        .toSet()
        .length;
    final averageDailyXP = daysWithData > 0
        ? (totalXP / daysWithData).round()
        : 0;

    // Get weekly statistics for comparison
    final weeklyStats = await _getWeeklyXPStatistics();

    return XPStatistics(
      totalXP: totalXP,
      currentXP: totalXP, // Current XP is total XP in the range
      averageDailyXP: averageDailyXP,
      bestSingleDay: bestSingleDay,
      weeklyStats: weeklyStats,
    );
  }

  /// Get weekly XP statistics for comparison
  Future<AnalyticsStatistics> _getWeeklyXPStatistics() async {
    final now = DateTime.now();
    final startOfWeek = DateTime(
      now.year,
      now.month,
      now.day - now.weekday + 1,
    );
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    // Use ObjectBox aggregate functions for efficient calculations
    final query = _xPHistoryBox
        .query(XPHistoryItem_.createdAt.betweenDate(startOfWeek, endOfWeek))
        .build();

    final total = query.count();
    if (total == 0) {
      query.close();
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    // Use aggregate functions for efficient calculations
    final totalWeeklyXP = query.property(XPHistoryItem_.amount).sum();
    final bestDay = query.property(XPHistoryItem_.amount).max();
    query.close();

    return AnalyticsStatistics(
      total: total,
      current: totalWeeklyXP,
      best: bestDay,
      successRate: 0.0, // Not applicable for XP
    );
  }
}
