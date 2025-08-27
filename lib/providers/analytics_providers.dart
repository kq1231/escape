import 'package:escape/models/analytics_models.dart';
import 'package:escape/repositories/analytics_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'analytics_providers.g.dart';

/// Streak Analytics Providers

/// Provider for streak contribution grid data (GitHub-style activity grid)
@riverpod
Future<List<StreakGridData>> streakGridData(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getStreakGridData(range: range);
}

/// Provider for streak progress data for line chart
@riverpod
Future<List<Map<String, dynamic>>> streakProgressData(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getStreakProgressData(range: range);
}

/// Provider for streak statistics
@riverpod
Future<StreakStatistics> streakStatistics(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getStreakStatistics(range: range);
}

/// Prayer Analytics Providers

/// Provider for prayer completion grid data
@riverpod
Future<List<PrayerGridData>> prayerGridData(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getPrayerGridData(range: range);
}

/// Provider for prayer completion breakdown by prayer type
@riverpod
Future<Map<String, int>> prayerBreakdown(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getPrayerBreakdown(range: range);
}

/// Provider for prayer statistics
@riverpod
Future<PrayerStatistics> prayerStatistics(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getPrayerStatistics(range: range);
}

/// Temptation Analytics Providers

/// Provider for temptation bar chart data (stacked bar chart)
@riverpod
Future<List<TemptationBarData>> temptationBarData(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getTemptationBarData(range: range);
}

/// Provider for temptation statistics
@riverpod
Future<TemptationStatistics> temptationStatistics(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getTemptationStatistics(range: range);
}

/// XP Analytics Providers

/// Provider for XP growth data for line chart (cumulative and daily)
@riverpod
Future<List<XPGrowthData>> xpGrowthData(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getXPGrowthData(range: range);
}

/// Provider for XP source breakdown for pie chart
@riverpod
Future<List<XPSourceData>> xpSourceBreakdown(
  Ref ref, {
  AnalyticsTimeRange? range,
}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getXPSourceBreakdown(range: range);
}

/// Provider for XP statistics
@riverpod
Future<XPStatistics> xpStatistics(Ref ref, {AnalyticsTimeRange? range}) async {
  final analyticsRepository = ref.read(analyticsRepositoryProvider.notifier);
  return await analyticsRepository.getXPStatistics(range: range);
}

/// Combined Analytics Providers

/// Provider for all streak analytics data
@riverpod
class StreakAnalytics extends _$StreakAnalytics {
  @override
  Future<Map<String, dynamic>> build({AnalyticsTimeRange? range}) async {
    final repository = ref.read(analyticsRepositoryProvider.notifier);

    final gridData = await repository.getStreakGridData(range: range);
    final progressData = await repository.getStreakProgressData(range: range);
    final statistics = await repository.getStreakStatistics(range: range);

    return {
      'gridData': gridData,
      'progressData': progressData,
      'statistics': statistics,
    };
  }

  /// Refresh all streak analytics data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await build());
  }
}

/// Provider for all prayer analytics data
@riverpod
class PrayerAnalytics extends _$PrayerAnalytics {
  @override
  Future<Map<String, dynamic>> build({AnalyticsTimeRange? range}) async {
    final repository = ref.read(analyticsRepositoryProvider.notifier);

    final gridData = await repository.getPrayerGridData(range: range);
    final breakdown = await repository.getPrayerBreakdown(range: range);
    final statistics = await repository.getPrayerStatistics(range: range);

    return {
      'gridData': gridData,
      'breakdown': breakdown,
      'statistics': statistics,
    };
  }

  /// Refresh all prayer analytics data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await build());
  }
}

/// Provider for all temptation analytics data
@riverpod
class TemptationAnalytics extends _$TemptationAnalytics {
  @override
  Future<Map<String, dynamic>> build({AnalyticsTimeRange? range}) async {
    final repository = ref.read(analyticsRepositoryProvider.notifier);

    final barData = await repository.getTemptationBarData(range: range);
    final statistics = await repository.getTemptationStatistics(range: range);

    return {'barData': barData, 'statistics': statistics};
  }

  /// Refresh all temptation analytics data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await build());
  }
}

/// Provider for all XP analytics data
@riverpod
class XPAnalytics extends _$XPAnalytics {
  @override
  Future<Map<String, dynamic>> build({AnalyticsTimeRange? range}) async {
    final repository = ref.read(analyticsRepositoryProvider.notifier);

    final growthData = await repository.getXPGrowthData(range: range);
    final sourceBreakdown = await repository.getXPSourceBreakdown(range: range);
    final statistics = await repository.getXPStatistics(range: range);

    return {
      'growthData': growthData,
      'sourceBreakdown': sourceBreakdown,
      'statistics': statistics,
    };
  }

  /// Refresh all XP analytics data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await build());
  }
}

/// Provider for all analytics data combined
@riverpod
class AllAnalytics extends _$AllAnalytics {
  @override
  Future<Map<String, dynamic>> build({AnalyticsTimeRange? range}) async {
    final repository = ref.read(analyticsRepositoryProvider.notifier);

    // Get all analytics data in parallel using Future.wait
    final results = await Future.wait([
      repository.getStreakStatistics(range: range),
      repository.getPrayerStatistics(range: range),
      repository.getTemptationStatistics(range: range),
      repository.getXPStatistics(range: range),
    ]);

    return {
      'streak': results[0],
      'prayer': results[1],
      'temptation': results[2],
      'xp': results[3],
    };
  }

  /// Refresh all analytics data
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await build());
  }
}
