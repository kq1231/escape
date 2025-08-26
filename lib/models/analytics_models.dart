import 'package:flutter/material.dart';

/// Analytics time range for filtering data
class AnalyticsTimeRange {
  final DateTime start;
  final DateTime end;
  final String label;

  const AnalyticsTimeRange({
    required this.start,
    required this.end,
    required this.label,
  });

  /// Get time range for last N days
  factory AnalyticsTimeRange.lastDays(int days) {
    final end = DateTime.now();
    final start = end.subtract(Duration(days: days - 1));
    return AnalyticsTimeRange(start: start, end: end, label: 'Last $days days');
  }

  /// Get time range for current week
  factory AnalyticsTimeRange.currentWeek() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, now.day - now.weekday + 1);
    final end = start.add(const Duration(days: 6));
    return AnalyticsTimeRange(start: start, end: end, label: 'This Week');
  }

  /// Get time range for current month
  factory AnalyticsTimeRange.currentMonth() {
    final now = DateTime.now();
    final start = DateTime(now.year, now.month, 1);
    final end = DateTime(now.year, now.month + 1, 0);
    return AnalyticsTimeRange(start: start, end: end, label: 'This Month');
  }

  /// Get time range for current year
  factory AnalyticsTimeRange.currentYear() {
    final now = DateTime.now();
    final start = DateTime(now.year, 1, 1);
    final end = DateTime(now.year, 12, 31);
    return AnalyticsTimeRange(start: start, end: end, label: 'This Year');
  }

  /// Check if a date is within this range
  bool contains(DateTime date) {
    return !date.isBefore(start) && !date.isAfter(end);
  }

  @override
  String toString() => 'AnalyticsTimeRange($label: $start to $end)';
}

/// Data model for streak contribution graph
class StreakGridData {
  final DateTime date;
  final int streakCount;
  final bool hasRelapse;
  final double intensity; // 0.0 to 1.0

  const StreakGridData({
    required this.date,
    required this.streakCount,
    required this.hasRelapse,
    required this.intensity,
  });

  /// Get color based on intensity and relapse status
  String getColor() {
    if (hasRelapse) return '#FF6B6B'; // Red for relapse
    if (intensity == 0) return '#E5E7EB'; // Gray for no activity
    // Green gradient based on intensity
    final greenValue = (100 + (intensity * 155)).round();
    return '#4ADE$greenValue'; // Green shades
  }

  @override
  String toString() =>
      'StreakGridData(date: $date, streakCount: $streakCount, intensity: $intensity)';
}

/// Data model for prayer completion grid
class PrayerGridData {
  final DateTime date;
  final int prayersCompleted; // 0-6
  final double intensity; // 0.0 to 1.0

  const PrayerGridData({
    required this.date,
    required this.prayersCompleted,
    required this.intensity,
  });

  /// Get color based on completion intensity
  String getColor() {
    if (prayersCompleted == 0) return '#E5E7EB'; // Gray for no prayers
    // Green gradient based on completion rate
    final greenValue = (100 + (intensity * 155)).round();
    return '#4ADE$greenValue'; // Green shades
  }

  @override
  String toString() =>
      'PrayerGridData(date: $date, prayersCompleted: $prayersCompleted, intensity: $intensity)';
}

/// Data model for temptation stacked bar chart
class TemptationBarData {
  final DateTime date;
  final int successfulCount;
  final int relapseCount;

  const TemptationBarData({
    required this.date,
    required this.successfulCount,
    required this.relapseCount,
  });

  /// Get total temptations for this date
  int get totalCount => successfulCount + relapseCount;

  @override
  String toString() =>
      'TemptationBarData(date: $date, successful: $successfulCount, relapse: $relapseCount)';
}

/// Statistics data model
class AnalyticsStatistics {
  final int total;
  final int current;
  final int best;
  final double successRate;
  final String? trend;

  const AnalyticsStatistics({
    required this.total,
    required this.current,
    required this.best,
    required this.successRate,
    this.trend,
  });
}

/// Prayer-specific statistics
class PrayerStatistics {
  final int totalPrayers;
  final int completedPrayers;
  final double completionRate;
  final Map<String, int> prayerBreakdown; // Prayer name to count
  final AnalyticsStatistics weeklyStats;

  const PrayerStatistics({
    required this.totalPrayers,
    required this.completedPrayers,
    required this.completionRate,
    required this.prayerBreakdown,
    required this.weeklyStats,
  });
}

/// Streak-specific statistics
class StreakStatistics {
  final int currentStreak;
  final int longestStreak;
  final int totalDays;
  final double successRate;
  final AnalyticsStatistics monthlyStats;

  const StreakStatistics({
    required this.currentStreak,
    required this.longestStreak,
    required this.totalDays,
    required this.successRate,
    required this.monthlyStats,
  });
}

/// Temptation-specific statistics
class TemptationStatistics {
  final int totalTemptations;
  final int successfulTemptations;
  final int relapses;
  final double successRate;
  final AnalyticsStatistics weeklyStats;

  const TemptationStatistics({
    required this.totalTemptations,
    required this.successfulTemptations,
    required this.relapses,
    required this.successRate,
    required this.weeklyStats,
  });
}

/// XP-specific statistics
class XPStatistics {
  final int totalXP;
  final int currentXP;
  final int averageDailyXP;
  final int bestSingleDay;
  final AnalyticsStatistics weeklyStats;

  const XPStatistics({
    required this.totalXP,
    required this.currentXP,
    required this.averageDailyXP,
    required this.bestSingleDay,
    required this.weeklyStats,
  });
}

/// Data model for XP growth chart
class XPGrowthData {
  final DateTime date;
  final int cumulativeXP;
  final int dailyXP;

  const XPGrowthData({
    required this.date,
    required this.cumulativeXP,
    required this.dailyXP,
  });

  @override
  String toString() =>
      'XPGrowthData(date: $date, cumulativeXP: $cumulativeXP, dailyXP: $dailyXP)';
}

/// Data model for XP source breakdown
class XPSourceData {
  final String source;
  final int xpAmount;
  final Color color;

  const XPSourceData({
    required this.source,
    required this.xpAmount,
    required this.color,
  });

  @override
  String toString() => 'XPSourceData(source: $source, xpAmount: $xpAmount)';
}
