import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';

class XPGrowthChart extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;

  const XPGrowthChart({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final growthDataAsync = ref.watch(xpGrowthDataProvider(range: timeRange));

    return growthDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (growthData) {
        if (growthData.isEmpty) {
          return const Center(child: Text('No XP data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'XP Growth',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              timeRange?.label ?? 'Last 30 days',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: _buildGrowthChart(context, growthData),
            ),
            const SizedBox(height: 20),
            _buildStatistics(context, growthData),
          ],
        );
      },
    );
  }

  Widget _buildGrowthChart(
    BuildContext context,
    List<XPGrowthData> growthData,
  ) {
    // Ensure sorted
    if (growthData.length > 1 &&
        growthData.first.date.isAfter(growthData.last.date)) {
      growthData = [...growthData]..sort((a, b) => a.date.compareTo(b.date));
    }

    int maxCumulativeXP = 0;
    int maxDailyXP = 0;

    for (final data in growthData) {
      if (data.cumulativeXP > maxCumulativeXP) {
        maxCumulativeXP = data.cumulativeXP;
      }
      if (data.dailyXP > maxDailyXP) maxDailyXP = data.dailyXP;
    }

    final scaleFactor = maxDailyXP == 0 ? 1.0 : (maxCumulativeXP / maxDailyXP);

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) =>
              FlLine(color: AppConstants.lightGray, strokeWidth: 1),
          getDrawingVerticalLine: (value) =>
              FlLine(color: AppConstants.lightGray, strokeWidth: 1),
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: (maxCumulativeXP / 5).ceilToDouble().clamp(
                1,
                double.infinity,
              ),
              getTitlesWidget: (value, meta) => Text(
                value.toInt().toString(),
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppConstants.mediumGray),
              ),
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < growthData.length) {
                  final date = growthData[index].date;
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '${date.day}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: (growthData.length - 1).toDouble(),
        minY: 0,
        maxY: (maxCumulativeXP * 1.1).toDouble(),
        lineBarsData: [
          // Cumulative XP line
          LineChartBarData(
            spots: [
              for (var i = 0; i < growthData.length; i++)
                FlSpot(i.toDouble(), growthData[i].cumulativeXP.toDouble()),
            ],
            isCurved: true,
            color: AppConstants.primaryGreen,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(show: growthData.length < 50),
            belowBarData: BarAreaData(
              show: true,
              color: AppConstants.primaryGreen.withValues(alpha: 0.1),
            ),
          ),
          // Daily XP line (scaled)
          LineChartBarData(
            spots: [
              for (var i = 0; i < growthData.length; i++)
                FlSpot(i.toDouble(), growthData[i].dailyXP * scaleFactor),
            ],
            isCurved: true,
            color: AppConstants.accentGreen,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(show: growthData.length < 50),
            belowBarData: BarAreaData(show: false),
          ),
        ],
      ),
    );
  }

  Widget _buildStatistics(BuildContext context, List<XPGrowthData> growthData) {
    if (growthData.isEmpty) return const SizedBox.shrink();

    final firstData = growthData.first;
    final lastData = growthData.last;
    final totalXP = lastData.cumulativeXP;
    final totalGained = lastData.cumulativeXP - firstData.cumulativeXP;

    int totalDailyXP = 0;
    int maxDailyXP = 0;

    for (final data in growthData) {
      totalDailyXP += data.dailyXP;
      if (data.dailyXP > maxDailyXP) maxDailyXP = data.dailyXP;
    }

    final avgDailyXP = totalDailyXP / growthData.length;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: AppConstants.lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppConstants.lightGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Total XP',
                  totalXP.toString(),
                  Icons.stars,
                  color: AppConstants.warningOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Gained',
                  totalGained.toString(),
                  Icons.trending_up,
                  color: AppConstants.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Avg Daily',
                  avgDailyXP.round().toString(),
                  Icons.calendar_today,
                  color: AppConstants.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Best Day',
                  maxDailyXP.toString(),
                  Icons.emoji_events,
                  color: AppConstants.accentGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon, {
    Color? color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color ?? AppConstants.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppConstants.mediumGray),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? AppConstants.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
