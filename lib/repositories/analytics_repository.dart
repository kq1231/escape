import 'dart:async';
import 'package:escape/models/xp_history_item_model.dart';
import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:escape/models/streak_model.dart';
import 'package:escape/models/prayer_model.dart';
import 'package:escape/models/temptation.dart';
import 'package:escape/models/analytics_models.dart';
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

    // Get all streaks in the date range
    final query = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final streaks = query.find();
    query.close();

    // Create a map of date to streak for easy lookup
    final streakMap = <DateTime, Streak>{};
    for (final streak in streaks) {
      final date = DateTime(
        streak.date.year,
        streak.date.month,
        streak.date.day,
      );
      streakMap[date] = streak;
    }

    // Generate grid data for each day in the range
    final gridData = <StreakGridData>[];
    final maxStreak = streaks
        .map((s) => s.count)
        .fold(0, (max, count) => count > max ? count : max);

    for (
      int i = 0;
      i < timeRange.end.difference(timeRange.start).inDays + 1;
      i++
    ) {
      final date = timeRange.start.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final streak = streakMap[normalizedDate];
      final hasRelapse = streak != null && !streak.isSuccess;
      final streakCount = streak?.count ?? 0;
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

  /// Get streak progress data for line chart
  Future<List<Map<String, dynamic>>> getStreakProgressData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    final query = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .order(Streak_.date)
        .build();

    final streaks = query.find();
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

    // Get all streaks in the range
    final query = _streakBox
        .query(Streak_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final streaks = query.find();
    query.close();

    if (streaks.isEmpty) {
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

    // Calculate statistics
    final currentStreak = streaks
        .where((s) => s.isSuccess)
        .fold(0, (max, s) => s.count > max ? s.count : max);
    final longestStreak = streaks.fold(
      0,
      (max, s) => s.count > max ? s.count : max,
    );
    final totalDays = streaks.length;
    final successfulDays = streaks.where((s) => s.isSuccess).length;
    final successRate = totalDays > 0 ? successfulDays / totalDays : 0.0;

    // Get monthly statistics for comparison
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

    final query = _streakBox
        .query(Streak_.date.betweenDate(startOfMonth, endOfMonth))
        .build();

    final monthlyStreaks = query.find();
    query.close();

    if (monthlyStreaks.isEmpty) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    final bestStreak = monthlyStreaks.fold(
      0,
      (max, s) => s.count > max ? s.count : max,
    );
    final successfulDays = monthlyStreaks.where((s) => s.isSuccess).length;
    final successRate = monthlyStreaks.isNotEmpty
        ? successfulDays / monthlyStreaks.length
        : 0.0;

    return AnalyticsStatistics(
      total: monthlyStreaks.length,
      current: monthlyStreaks.last.count,
      best: bestStreak,
      successRate: successRate,
    );
  }

  /// Prayer Analytics Methods

  /// Get prayer completion grid data
  Future<List<PrayerGridData>> getPrayerGridData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get all prayers in the date range
    final query = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final prayers = query.find();
    query.close();

    // Create a map of date to prayers for easy lookup
    final prayerMap = <DateTime, List<Prayer>>{};
    for (final prayer in prayers) {
      final date = DateTime(
        prayer.date.year,
        prayer.date.month,
        prayer.date.day,
      );
      prayerMap.putIfAbsent(date, () => []).add(prayer);
    }

    // Generate grid data for each day in the range
    final gridData = <PrayerGridData>[];
    final maxPrayers = 6; // Maximum possible prayers per day

    for (
      int i = 0;
      i < timeRange.end.difference(timeRange.start).inDays + 1;
      i++
    ) {
      final date = timeRange.start.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final dayPrayers = prayerMap[normalizedDate] ?? [];
      final prayersCompleted = dayPrayers.where((p) => p.isCompleted).length;
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

  /// Get prayer completion breakdown by prayer type
  Future<Map<String, int>> getPrayerBreakdown({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    final query = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final prayers = query.find();
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

    // Get all prayers in the range
    final query = _prayerBox
        .query(Prayer_.date.betweenDate(timeRange.start, timeRange.end))
        .build();

    final prayers = query.find();
    query.close();

    if (prayers.isEmpty) {
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

    // Calculate statistics
    final completedPrayers = prayers.where((p) => p.isCompleted).length;
    final completionRate = prayers.isNotEmpty
        ? completedPrayers / prayers.length
        : 0.0;
    final breakdown = await getPrayerBreakdown(range: timeRange);

    // Get weekly statistics for comparison
    final weeklyStats = await _getWeeklyPrayerStatistics();

    return PrayerStatistics(
      totalPrayers: prayers.length,
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

    final query = _prayerBox
        .query(Prayer_.date.betweenDate(startOfWeek, endOfWeek))
        .build();

    final weeklyPrayers = query.find();
    query.close();

    if (weeklyPrayers.isEmpty) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    final completedPrayers = weeklyPrayers.where((p) => p.isCompleted).length;
    final completionRate = weeklyPrayers.isNotEmpty
        ? completedPrayers / weeklyPrayers.length
        : 0.0;

    return AnalyticsStatistics(
      total: weeklyPrayers.length,
      current: completedPrayers,
      best: completedPrayers, // For prayers, best is the completion count
      successRate: completionRate,
    );
  }

  /// Temptation Analytics Methods

  /// Get temptation bar chart data (stacked bar chart)
  Future<List<TemptationBarData>> getTemptationBarData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get all temptations in the date range
    final query = _temptationBox
        .query(
          Temptation_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();

    final temptations = query.find();
    query.close();

    // Create a map of date to temptations for easy lookup
    final temptationMap = <DateTime, List<Temptation>>{};
    for (final temptation in temptations) {
      final date = DateTime(
        temptation.createdAt.year,
        temptation.createdAt.month,
        temptation.createdAt.day,
      );
      temptationMap.putIfAbsent(date, () => []).add(temptation);
    }

    // Generate bar data for each day in the range
    final barData = <TemptationBarData>[];

    for (
      int i = 0;
      i < timeRange.end.difference(timeRange.start).inDays + 1;
      i++
    ) {
      final date = timeRange.start.add(Duration(days: i));
      final normalizedDate = DateTime(date.year, date.month, date.day);

      final dayTemptations = temptationMap[normalizedDate] ?? [];
      final successfulCount = dayTemptations
          .where((t) => t.wasSuccessful)
          .length;
      final relapseCount = dayTemptations.where((t) => !t.wasSuccessful).length;

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

  /// Get temptation statistics
  Future<TemptationStatistics> getTemptationStatistics({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get all temptations in the range
    final query = _temptationBox
        .query(
          Temptation_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();

    final temptations = query.find();
    query.close();

    if (temptations.isEmpty) {
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

    // Calculate statistics
    final successfulTemptations = temptations
        .where((t) => t.wasSuccessful)
        .length;
    final relapses = temptations.where((t) => !t.wasSuccessful).length;
    final successRate = temptations.isNotEmpty
        ? successfulTemptations / temptations.length
        : 0.0;

    // Get weekly statistics for comparison
    final weeklyStats = await _getWeeklyTemptationStatistics();

    return TemptationStatistics(
      totalTemptations: temptations.length,
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

    final query = _temptationBox
        .query(Temptation_.createdAt.betweenDate(startOfWeek, endOfWeek))
        .build();

    final weeklyTemptations = query.find();
    query.close();

    if (weeklyTemptations.isEmpty) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    final successfulTemptations = weeklyTemptations
        .where((t) => t.wasSuccessful)
        .length;
    final successRate = weeklyTemptations.isNotEmpty
        ? successfulTemptations / weeklyTemptations.length
        : 0.0;

    return AnalyticsStatistics(
      total: weeklyTemptations.length,
      current: successfulTemptations,
      best: successfulTemptations, // For temptations, best is the success count
      successRate: successRate,
    );
  }

  /// XP Analytics Methods

  /// Get XP growth data for line chart (cumulative and daily)
  Future<List<XPGrowthData>> getXPGrowthData({
    AnalyticsTimeRange? range,
  }) async {
    final timeRange = _getTimeRange(range);

    // Get all XP history items in the date range
    final query = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .order(XPHistoryItem_.createdAt)
        .build();

    final xpItems = query.find();
    query.close();

    if (xpItems.isEmpty) {
      return [];
    }

    // Sort items by date
    xpItems.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    // Generate growth data
    final growthData = <XPGrowthData>[];
    int cumulativeXP = 0;

    for (int i = 0; i < xpItems.length; i++) {
      final item = xpItems[i];
      cumulativeXP += item.amount;

      // Group by day for daily totals
      final date = DateTime(
        item.createdAt.year,
        item.createdAt.month,
        item.createdAt.day,
      );

      // Calculate daily XP (sum of all XP for this day)
      final dayItems = xpItems
          .where(
            (xp) => DateTime(
              xp.createdAt.year,
              xp.createdAt.month,
              xp.createdAt.day,
            ).isAtSameMomentAs(date),
          )
          .toList();

      final dailyXP = dayItems.fold(0, (sum, xp) => sum + xp.amount);

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

    // Get all XP history items in the date range
    final query = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();

    final xpItems = query.find();
    query.close();

    // Categorize XP by source
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
      final desc = item.description.toLowerCase();

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

      sourceMap[source] = (sourceMap[source] ?? 0) + item.amount;
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

  /// Get XP statistics
  Future<XPStatistics> getXPStatistics({AnalyticsTimeRange? range}) async {
    final timeRange = _getTimeRange(range);

    // Get all XP history items in the range
    final query = _xPHistoryBox
        .query(
          XPHistoryItem_.createdAt.betweenDate(timeRange.start, timeRange.end),
        )
        .build();

    final xpItems = query.find();
    query.close();

    if (xpItems.isEmpty) {
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

    // Calculate statistics
    final totalXP = xpItems.fold(0, (sum, item) => sum + item.amount);
    final bestSingleDay = xpItems.fold(
      0,
      (max, item) => item.amount > max ? item.amount : max,
    );

    // Calculate average daily XP
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

    final query = _xPHistoryBox
        .query(XPHistoryItem_.createdAt.betweenDate(startOfWeek, endOfWeek))
        .build();

    final weeklyXPItems = query.find();
    query.close();

    if (weeklyXPItems.isEmpty) {
      return AnalyticsStatistics(
        total: 0,
        current: 0,
        best: 0,
        successRate: 0.0,
      );
    }

    final totalWeeklyXP = weeklyXPItems.fold(
      0,
      (sum, item) => sum + item.amount,
    );
    final bestDay = weeklyXPItems.fold(
      0,
      (max, item) => item.amount > max ? item.amount : max,
    );

    return AnalyticsStatistics(
      total: weeklyXPItems.length,
      current: totalWeeklyXP,
      best: bestDay,
      successRate: 0.0, // Not applicable for XP
    );
  }
}
