import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/features/analytics/molecules/quick_stats_card.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/providers/quick_stats_provider.dart';

class QuickStatsOrganism extends ConsumerWidget {
  const QuickStatsOrganism({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final quickStatsAsync = ref.watch(quickStatsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Stats',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 32,
          ),
        ),
        const SizedBox(height: AppConstants.spacingM),
        quickStatsAsync.when(
          data: (stats) {
            return Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: QuickStatsCard(
                        title: 'Prayers',
                        value: '${stats.totalPrayers}',
                        subtitle: 'All time',
                        icon: Icons.mosque,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: QuickStatsCard(
                        title: 'Best Streak',
                        value: '${stats.bestStreak}',
                        subtitle: 'All time',
                        icon: Icons.local_fire_department,
                        iconColor: AppConstants.primaryGreen,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppConstants.spacingM),
                Row(
                  children: [
                    Expanded(
                      child: QuickStatsCard(
                        title: 'Mood',
                        value: '${stats.currentMood}/10',
                        subtitle: 'Today',
                        icon: Icons.mood,
                        iconColor: Colors.orange,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                    Expanded(
                      child: QuickStatsCard(
                        title: 'Progress',
                        value: '${stats.progressToGoal}%',
                        subtitle: 'To goal',
                        icon: Icons.trending_up,
                        iconColor: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Text('Error: $error'),
        ),
      ],
    );
  }
}
