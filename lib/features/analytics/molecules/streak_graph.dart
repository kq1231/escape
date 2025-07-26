import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../atoms/chart_container.dart';

class StreakGraph extends StatelessWidget {
  final List<StreakData> data;
  final String title;
  final String? subtitle;

  const StreakGraph({
    super.key,
    required this.data,
    this.title = 'Streak History',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      title: title,
      subtitle: subtitle,
      child: SizedBox(
        height: 200,
        child: BarChart(
          BarChartData(
            barGroups: _generateBarGroups(),
            titlesData: FlTitlesData(
              show: true,
              rightTitles: AxisTitles(
                sideTitles: SideTitles(showTitles: false),
              ),
              topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    if (value.toInt() < data.length && value.toInt() >= 0) {
                      final date = data[value.toInt()].date;
                      return Text(
                        '${date.day}',
                        style: AppTheme.bodyMedium.copyWith(
                          color: AppTheme.mediumGray,
                          fontWeight: FontWeight.w500,
                        ),
                      );
                    }
                    return const Text('');
                  },
                  reservedSize: 30,
                ),
              ),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  getTitlesWidget: (value, meta) {
                    return Text(
                      value.toInt().toString(),
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
                        fontWeight: FontWeight.w500,
                      ),
                    );
                  },
                  reservedSize: 30,
                ),
              ),
            ),
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 1,
              getDrawingHorizontalLine: (value) {
                return FlLine(color: AppTheme.lightGray, strokeWidth: 1);
              },
            ),
            borderData: FlBorderData(
              show: true,
              border: Border.all(color: AppTheme.lightGray),
            ),
            barTouchData: BarTouchData(
              enabled: true,
              touchTooltipData: BarTouchTooltipData(
                getTooltipItem: (group, groupIndex, rod, rodIndex) {
                  return BarTooltipItem(
                    '${data[groupIndex].streakCount}',
                    AppTheme.bodyMedium.copyWith(
                      color: AppTheme.darkGray,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<BarChartGroupData> _generateBarGroups() {
    List<BarChartGroupData> groups = [];
    for (int i = 0; i < data.length; i++) {
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: data[i].streakCount.toDouble(),
              color: data[i].isActive
                  ? AppTheme.primaryGreen
                  : AppTheme.mediumGray,
              width: 16,
              borderRadius: BorderRadius.zero,
            ),
          ],
        ),
      );
    }
    return groups;
  }
}

class StreakData {
  final DateTime date;
  final int streakCount;
  final bool isActive;

  StreakData({
    required this.date,
    required this.streakCount,
    this.isActive = true,
  });
}
