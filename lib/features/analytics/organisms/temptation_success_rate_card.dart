import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';
import 'success_rate_card.dart';

class TemptationSuccessRateCard extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;

  const TemptationSuccessRateCard({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final temptationStatsAsync = ref.watch(
      temptationStatisticsProvider(range: timeRange),
    );

    return temptationStatsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(
        child: Text(
          'Error loading temptation stats: $error',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.errorRed),
        ),
      ),
      data: (stats) {
        return SuccessRateCard(
          successRate: stats.successRate * 100,
          title: 'Temptation Success Rate',
          subtitle:
              '${stats.successfulTemptations}/${stats.totalTemptations} temptations overcome',
          icon: Icons.shield,
          iconColor: AppTheme.successGreen,
          trend: _getTrend(stats.successRate),
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
