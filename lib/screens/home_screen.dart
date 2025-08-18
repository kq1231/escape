import 'package:escape/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/streak/organisms/streak_organism.dart';
import '../features/emergency/atoms/emergency_button.dart';
import '../features/temptation/screens/temptation_flow_screen.dart';
import '../features/prayer/molecules/daily_prayer_grid.dart';
import '../features/analytics/organisms/quick_stats_organism.dart';
import 'package:escape/theme/app_theme.dart';
import '../providers/prayer_provider.dart';
import '../providers/streak_provider.dart';
import '../features/prayer/atoms/triple_state_checkbox.dart';
import '../models/prayer_model.dart';
import '../repositories/prayer_repository.dart';
import '../features/streak/widgets/streak_modal.dart';
import '../features/temptation/services/temptation_storage_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // State variables for the home screen
  final bool _isEmergencyButtonEnabled = true;

  // Add method to check for active temptation
  bool _hasActiveTemptation() {
    final temptationStorageService = TemptationStorageService();
    return temptationStorageService.hasActiveTemptation();
  }

  void _onStreakCardTap(BuildContext context, Streak? streak) {
    // Show streak modal
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (BuildContext context) {
        return StreakModal(streak: streak);
      },
    );
  }

  void _onEmergencyButtonPressed(BuildContext context) {
    if (_isEmergencyButtonEnabled) {
      // Navigate to emergency screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TemptationFlowScreen()),
      );
    }
  }

  void _onStatCardTap(BuildContext context, String statType) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigate to $statType details')));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());
    final todaysStreakAsync = ref.watch(todaysStreakProvider);

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Show active temptation warning if exists
            if (_hasActiveTemptation()) ...[
              Container(
                padding: const EdgeInsets.all(AppTheme.spacingL),
                margin: const EdgeInsets.symmetric(
                  horizontal: 0,
                  vertical: AppTheme.spacingM,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.errorRed.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppTheme.radiusXL),
                  border: Border.all(
                    color: AppTheme.errorRed.withValues(alpha: 0.3),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.warning_amber,
                          color: AppTheme.errorRed,
                          size: 24,
                        ),
                        const SizedBox(width: AppTheme.spacingS),
                        Text(
                          'Active Temptation Session',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppTheme.errorRed,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppTheme.spacingM),
                    Text(
                      'You have an ongoing temptation session. '
                      'Tap below to continue your journey.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.darkGray,
                      ),
                    ),
                    const SizedBox(height: AppTheme.spacingL),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const TemptationFlowScreen(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.errorRed,
                          foregroundColor: AppTheme.white,
                        ),
                        child: const Text('Continue Session'),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppTheme.spacingXL),
            ],

            // Streak Counter at the top
            todaysStreakAsync.when(
              data: (streak) {
                return StreakOrganism(
                  streak: streak ?? Streak(count: 0),
                  labelText: 'Days Clean',
                  onTap: () => _onStreakCardTap(context, streak),
                  isActive: true,
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Prayer grid
            todaysPrayersAsync.when(
              data: (prayers) {
                return DailyPrayerGrid(
                  prayers: prayers,
                  onPrayerStateChanged: (prayer, state) {
                    // Handle prayer state changes
                    switch (state) {
                      case CheckboxState.checked:
                        // Create or update prayer as completed
                        if (prayer.id == 0) {
                          // Create new prayer
                          final newPrayer = Prayer(
                            name: prayer.name,
                            isCompleted: true,
                            date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          );
                          ref
                              .read(prayerRepositoryProvider.notifier)
                              .createPrayer(newPrayer);
                        } else {
                          // Update existing prayer
                          final updatedPrayer = prayer.copyWith(
                            isCompleted: true,
                          );
                          ref
                              .read(prayerRepositoryProvider.notifier)
                              .updatePrayer(updatedPrayer);
                        }
                        break;
                      case CheckboxState.unchecked:
                        // Create or update prayer as not completed
                        if (prayer.id == 0) {
                          // Create new prayer
                          final newPrayer = Prayer(
                            name: prayer.name,
                            isCompleted: false,
                            date: DateTime(
                              DateTime.now().year,
                              DateTime.now().month,
                              DateTime.now().day,
                            ),
                          );
                          ref
                              .read(prayerRepositoryProvider.notifier)
                              .createPrayer(newPrayer);
                        } else {
                          // Update existing prayer
                          final updatedPrayer = prayer.copyWith(
                            isCompleted: false,
                          );
                          ref
                              .read(prayerRepositoryProvider.notifier)
                              .updatePrayer(updatedPrayer);
                        }
                        break;
                      case CheckboxState.empty:
                        // Delete prayer if it exists
                        if (prayer.id != 0) {
                          ref
                              .read(prayerRepositoryProvider.notifier)
                              .deletePrayer(prayer.id);
                        }
                        break;
                    }
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, stack) => Text('Error: $error'),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Emergency Button
            Center(
              child: EmergencyButton(
                text: 'I Need Help',
                onPressed: () => _onEmergencyButtonPressed(context),
                icon: Icons.favorite,
                width: double.infinity,
                height: 60,
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Quick Stats Mini Analytics Preview
            QuickStatsOrganism(
              onPrayersTap: () => _onStatCardTap(context, 'Prayers'),
              onBestStreakTap: () => _onStatCardTap(context, 'Best Streak'),
              onMoodTap: () => _onStatCardTap(context, 'Mood'),
              onProgressTap: () => _onStatCardTap(context, 'Progress'),
            ),
          ],
        ),
      ),
    );
  }
}
