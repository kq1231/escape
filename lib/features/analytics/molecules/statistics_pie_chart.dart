import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:fl_chart/fl_chart.dart';
import '../atoms/chart_container.dart';

class StatisticsPieChart extends StatelessWidget {
  final List<StatisticData> data;
  final String title;
  final String? subtitle;

  const StatisticsPieChart({
    super.key,
    required this.data,
    this.title = 'Statistics Distribution',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      title: title,
      subtitle: subtitle,
      child: SizedBox(
        height: 200,
        child: PieChart(
          PieChartData(
            sections: _generateSections(context),
            centerSpaceRadius: 40,
            sectionsSpace: 2,
            pieTouchData: PieTouchData(
              touchCallback: (FlTouchEvent event, pieTouchResponse) {
                // Handle touch events if needed
              },
            ),
          ),
        ),
      ),
    );
  }

  List<PieChartSectionData> _generateSections(BuildContext ctx) {
    List<PieChartSectionData> sections = [];
    double total = data.fold(0, (sum, item) => sum + item.value);

    for (int i = 0; i < data.length; i++) {
      final percentage = (data[i].value / total) * 100;
      sections.add(
        PieChartSectionData(
          color: data[i].color ?? _getColorByIndex(i),
          value: data[i].value,
          title: '${percentage.toStringAsFixed(1)}%',
          radius: 50,
          titleStyle: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      );
    }
    return sections;
  }

  Color _getColorByIndex(int index) {
    List<Color> colors = [
      AppTheme.primaryGreen,
      AppTheme.lightGreen,
      AppTheme.accentGreen,
      AppTheme.warningOrange,
      AppTheme.successGreen,
    ];
    return colors[index % colors.length];
  }
}

class StatisticData {
  final String label;
  final double value;
  final Color? color;

  StatisticData({required this.label, required this.value, this.color});
}
