import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:escape/theme/app_constants.dart';
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
              ).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray),
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
    // Sort data by date and ensure no null/infinite values
    final validBarData = barData
        .where(
          (data) =>
              data.successfulCount >= 0 &&
              data.relapseCount >= 0 &&
              data.successfulCount.isFinite &&
              data.relapseCount.isFinite,
        )
        .toList();

    validBarData.sort((a, b) => a.date.compareTo(b.date));

    if (validBarData.isEmpty) {
      return const Center(child: Text('No valid data to display'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _calculateMaxY(validBarData),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 40,
              interval: _calculateInterval(validBarData),
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.mediumGray,
                  ),
                );
              },
            ),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 30,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < validBarData.length) {
                  final date = validBarData[index].date;
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
                return const Text('');
              },
            ),
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: validBarData.asMap().entries.map((entry) {
          final index = entry.key;
          final data = entry.value;
          final successfulCount = data.successfulCount.toDouble();
          final relapseCount = data.relapseCount.toDouble();
          final total = successfulCount + relapseCount;

          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: total,
                color: AppConstants.errorRed,
                width: 20,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                rodStackItems: total > 0
                    ? [
                        BarChartRodStackItem(
                          0,
                          successfulCount,
                          AppConstants.successGreen,
                        ),
                      ]
                    : [],
              ),
            ],
          );
        }).toList(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(color: AppConstants.lightGray, strokeWidth: 1);
          },
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final data = validBarData[group.x];
              return BarTooltipItem(
                'Date: ${data.date.day}/${data.date.month}\n'
                'Successful: ${data.successfulCount}\n'
                'Relapsed: ${data.relapseCount}\n'
                'Total: ${data.successfulCount + data.relapseCount}',
                const TextStyle(color: Colors.white),
              );
            },
          ),
        ),
      ),
    );
  }

  double _calculateMaxY(List<TemptationBarData> barData) {
    if (barData.isEmpty) return 10;

    final maxTotal = barData
        .map((data) => data.successfulCount + data.relapseCount)
        .reduce((a, b) => a > b ? a : b);

    // Add 10% padding to the top
    return (maxTotal * 1.1).ceilToDouble();
  }

  double? _calculateInterval(List<TemptationBarData> barData) {
    final maxY = _calculateMaxY(barData);
    if (maxY <= 10) return 1;
    if (maxY <= 50) return 5;
    if (maxY <= 100) return 10;
    return null; // Let fl_chart decide
  }

  Widget _buildLegend(BuildContext context) {
    return Row(
      children: [
        _buildLegendItem(context, 'Successful', AppConstants.successGreen),
        const SizedBox(width: 24),
        _buildLegendItem(context, 'Relapsed', AppConstants.errorRed),
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
          ).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray),
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
            'Summary',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.primaryGreen,
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
                  color: AppConstants.successGreen,
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
                  color: AppConstants.successGreen,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatItem(
                  context,
                  'Relapsed',
                  totalRelapsed.toString(),
                  Icons.thumb_down,
                  color: AppConstants.errorRed,
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
