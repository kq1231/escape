import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/stat_card.dart';
import '../molecules/progress_chart.dart';
import '../molecules/streak_graph.dart';
import '../molecules/statistics_pie_chart.dart';

class AnalyticsDashboard extends StatelessWidget {
  final List<StatCard> statCards;
  final ProgressChart progressChart;
  final StreakGraph streakGraph;
  final StatisticsPieChart? statisticsPieChart;
  final String? title;
  final VoidCallback? onSettingsPressed;

  const AnalyticsDashboard({
    super.key,
    required this.statCards,
    required this.progressChart,
    required this.streakGraph,
    this.statisticsPieChart,
    this.title,
    this.onSettingsPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header section
        if (title != null || onSettingsPressed != null) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Text(
                  title!,
                  style: AppTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 32, // Increased from default headlineMedium size
                  ),
                ),
              if (onSettingsPressed != null)
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: onSettingsPressed,
                  color: AppTheme.mediumGray,
                ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),
        ],
        // Stats grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: AppTheme.spacingM,
            mainAxisSpacing: AppTheme.spacingM,
            childAspectRatio: 1.2,
          ),
          itemCount: statCards.length,
          itemBuilder: (context, index) {
            return statCards[index];
          },
        ),
        const SizedBox(height: AppTheme.spacingXL),
        // Progress chart
        progressChart,
        const SizedBox(height: AppTheme.spacingXL),
        // Streak graph
        streakGraph,
        if (statisticsPieChart != null) ...[
          const SizedBox(height: AppTheme.spacingXL),
          statisticsPieChart!,
        ],
      ],
    );
  }
}
