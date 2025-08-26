import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';
import 'success_rate_card.dart';

class PrayerSuccessRateCard extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;

  const PrayerSuccessRateCard({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerStatsAsync = ref.watch(
      prayerStatisticsProvider(range: timeRange),
    );

    return prayerStatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading prayer stats: $error',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.errorRed),
        ),
      ),
      data: (stats) {
        return SuccessRateCard(
          successRate: stats.completionRate * 100,
          title: 'Prayer Success Rate',
          subtitle:
              '${stats.completedPrayers}/${stats.totalPrayers} prayers completed',
          icon: Icons.mosque,
          iconColor: AppTheme.primaryGreen,
          trend: _getTrend(stats.completionRate),
        );
      },
    );
  }

  String? _getTrend(double currentRate) {
    // This is a simplified trend calculation
    // In a real app, you'd compare with previous period
    if (currentRate >= 0.8) return 'up';
    if (currentRate <= 0.4) return 'down';
    return null;
  }
}
