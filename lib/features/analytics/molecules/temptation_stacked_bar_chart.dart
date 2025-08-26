import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';

class TemptationStackedBarChart extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;

  const TemptationStackedBarChart({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final barDataAsync = ref.watch(temptationBarDataProvider(range: timeRange));

    return barDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (barData) {
        if (barData.isEmpty) {
          return const Center(child: Text('No temptation data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temptation Success Rate',
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
            SizedBox(height: 300, child: _buildBarChart(context, barData)),
            const SizedBox(height: 20),
            _buildLegend(context),
            const SizedBox(height: 20),
            _buildStatistics(context, barData),
          ],
        );
      },
    );
  }

  Widget _buildBarChart(BuildContext context, List<TemptationBarData> barData) {
    // Sort data by date
    barData.sort((a, b) => a.date.compareTo(b.date));

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
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
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < barData.length) {
                  final date = barData[index].date;
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
        barGroups: barData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: data.successfulCount.toDouble(),
                color: AppTheme.successGreen,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
              BarChartRodData(
                toY: data.relapseCount.toDouble(),
                color: AppTheme.errorRed,
                width: 20,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
            showingTooltipIndicators: [0],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: AppTheme.lightGray, strokeWidth: 1);
          },
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _buildLegendItem(context, 'Successful', AppTheme.successGreen),
        const SizedBox(width: 24),
        _buildLegendItem(context, 'Relapsed', AppTheme.errorRed),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
        ),
      ],
    );
  }

  Widget _buildStatistics(
    BuildContext context,
    List<TemptationBarData> barData,
  ) {
    if (barData.isEmpty) return const SizedBox.shrink();

    final totalSuccessful = barData.fold(
      0,
      (sum, data) => sum + data.successfulCount,
    );
    final totalRelapsed = barData.fold(
      0,
      (sum, data) => sum + data.relapseCount,
    );
    final total = totalSuccessful + totalRelapsed;
    final successRate = total > 0 ? (totalSuccessful / total * 100).round() : 0;

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
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Total Attempts',
                  total.toString(),
                  Icons.bar_chart,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Success Rate',
                  '$successRate%',
                  Icons.check_circle,
                  color: AppTheme.successGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  context,
                  'Successful',
                  totalSuccessful.toString(),
                  Icons.thumb_up,
                  color: AppTheme.successGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Relapsed',
                  totalRelapsed.toString(),
                  Icons.thumb_down,
                  color: AppTheme.errorRed,
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
