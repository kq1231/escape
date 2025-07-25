import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/stat_card.dart';
import '../molecules/progress_chart.dart';
import '../molecules/streak_graph.dart';

class AnalyticsDashboard extends StatelessWidget {
  final List<StatCard> statCards;
  final ProgressChart progressChart;
  final StreakGraph streakGraph;
  final String? title;
  final VoidCallback? onSettingsPressed;

  const AnalyticsDashboard({
    super.key,
    required this.statCards,
    required this.progressChart,
    required this.streakGraph,
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
                  style: OnboardingTheme.headlineMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              if (onSettingsPressed != null)
                IconButton(
                  icon: const Icon(Icons.settings_outlined),
                  onPressed: onSettingsPressed,
                  color: OnboardingTheme.mediumGray,
                ),
            ],
          ),
          const SizedBox(height: OnboardingTheme.spacingL),
        ],
        // Stats grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: OnboardingTheme.spacingM,
            mainAxisSpacing: OnboardingTheme.spacingM,
            childAspectRatio: 1.2,
          ),
          itemCount: statCards.length,
          itemBuilder: (context, index) {
            return statCards[index];
          },
        ),
        const SizedBox(height: OnboardingTheme.spacingXL),
        // Progress chart
        progressChart,
        const SizedBox(height: OnboardingTheme.spacingXL),
        // Streak graph
        streakGraph,
      ],
    );
  }
}
