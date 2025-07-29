import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../atoms/chart_container.dart';

class ProgressChart extends StatelessWidget {
  final List<ProgressData> data;
  final String title;
  final String? subtitle;

  const ProgressChart({
    super.key,
    required this.data,
    this.title = 'Progress Overview',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      title: title,
      subtitle: subtitle,
      child: LayoutBuilder(
        builder: (context, constraints) {
          return SizedBox(
            height: 200,
            width: constraints.maxWidth,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: _generateSpots(),
                    isCurved: true,
                    color: AppTheme.primaryGreen,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 5,
                          color: AppTheme.primaryGreen,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppTheme.primaryGreen.withValues(alpha: 0.1),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  show: true,
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < data.length && value.toInt() >= 0) {
                          final date = data[value.toInt()].date;
                          return Text(
                            '${date.day}/${date.month}',
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
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
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(
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
                minX: 0,
                maxX: data.length > 1 ? (data.length - 1).toDouble() : 1,
                minY: _getMinValue(),
                maxY: _getMaxValue(),
              ),
            ),
          );
        },
      ),
    );
  }

  List<FlSpot> _generateSpots() {
    List<FlSpot> spots = [];
    for (int i = 0; i < data.length; i++) {
      spots.add(FlSpot(i.toDouble(), data[i].value));
    }
    return spots;
  }

  double _getMinValue() {
    if (data.isEmpty) return 0;
    double min = data[0].value;
    for (var item in data) {
      if (item.value < min) min = item.value;
    }
    // Add some padding
    return min > 1 ? min - 1 : 0;
  }

  double _getMaxValue() {
    if (data.isEmpty) return 5;
    double max = data[0].value;
    for (var item in data) {
      if (item.value > max) max = item.value;
    }
    // Add some padding
    return max + 1;
  }
}

class ProgressData {
  final DateTime date;
  final double value;
  final Color? color;

  ProgressData({required this.date, required this.value, this.color});
}
