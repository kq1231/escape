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
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
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
    // Sort data by date
    growthData.sort((a, b) => a.date.compareTo(b.date));

    // Get max values for scaling
    final maxCumulativeXP = growthData.fold(
      0,
      (max, data) => data.cumulativeXP > max ? data.cumulativeXP : max,
    );
    final maxDailyXP = growthData.fold(
      0,
      (max, data) => data.dailyXP > max ? data.dailyXP : max,
    );

    return LineChart(
      LineChartData(
        gridData: FlGridData(
          show: true,
          drawVerticalLine: true,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: AppTheme.lightGray, strokeWidth: 1);
          },
          getDrawingVerticalLine: (value) {
            return FlLine(color: AppTheme.lightGray, strokeWidth: 1);
          },
        ),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 60,
              interval: 1,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
                );
              },
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
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  );
                }
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        minX: 0,
        maxX: growthData.length - 1.0,
        minY: 0,
        maxY: (maxCumulativeXP * 1.1).toDouble(),
        lineBarsData: [
          // Cumulative XP line
          LineChartBarData(
            spots: growthData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              return FlSpot(index.toDouble(), data.cumulativeXP.toDouble());
            }).toList(),
            isCurved: true,
            color: AppTheme.primaryGreen,
            barWidth: 3,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 4,
                  color: AppTheme.primaryGreen,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
            belowBarData: BarAreaData(
              show: true,
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
            ),
          ),
          // Daily XP line (scaled to fit)
          LineChartBarData(
            spots: growthData.asMap().entries.map((entry) {
              final index = entry.key;
              final data = entry.value;
              // Scale daily XP to fit on the same chart
              final scaledDailyXP =
                  data.dailyXP * (maxCumulativeXP / maxDailyXP);
              return FlSpot(index.toDouble(), scaledDailyXP);
            }).toList(),
            isCurved: true,
            color: AppTheme.accentGreen,
            barWidth: 2,
            isStrokeCapRound: true,
            dotData: FlDotData(
              show: true,
              getDotPainter: (spot, percent, barData, index) {
                return FlDotCirclePainter(
                  radius: 3,
                  color: AppTheme.accentGreen,
                  strokeWidth: 2,
                  strokeColor: Colors.white,
                );
              },
            ),
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
    final avgDailyXP =
        growthData.fold(0, (sum, data) => sum + data.dailyXP) /
        growthData.length;
    final maxDailyXP = growthData.fold(
      0,
      (max, data) => data.dailyXP > max ? data.dailyXP : max,
    );

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.lightGreen),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'XP Statistics',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
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
                  color: AppTheme.warningOrange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Gained',
                  totalGained.toString(),
                  Icons.trending_up,
                  color: AppTheme.successGreen,
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
                  color: AppTheme.primaryGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Best Day',
                  maxDailyXP.toString(),
                  Icons.emoji_events,
                  color: AppTheme.accentGreen,
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
        Icon(icon, color: color ?? AppTheme.primaryGreen, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
              ),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color ?? AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
