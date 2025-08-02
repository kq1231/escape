import 'package:escape/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/streak/organisms/streak_organism.dart';
import '../features/emergency/atoms/emergency_button.dart';
import '../features/emergency/screens/emergency_screen.dart';
import '../features/prayer/molecules/daily_prayer_grid.dart';
import '../features/analytics/organisms/quick_stats_organism.dart';
import 'package:escape/theme/app_theme.dart';
import '../providers/prayer_provider.dart';
import '../providers/streak_provider.dart';
import '../features/prayer/atoms/triple_state_checkbox.dart';
import '../models/prayer_model.dart';
import '../repositories/prayer_repository.dart';
import '../features/streak/widgets/streak_modal.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // State variables for the home screen
  final bool _isEmergencyButtonEnabled = true;

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
        MaterialPageRoute(builder: (context) => const EmergencyScreen()),
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
                text: 'Emergency Help',
                onPressed: () => _onEmergencyButtonPressed(context),
                icon: Icons.emergency,
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
