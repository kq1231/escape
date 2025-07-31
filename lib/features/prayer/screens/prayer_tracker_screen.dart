import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../molecules/daily_prayer_grid.dart';
import 'package:escape/theme/app_theme.dart';
import '../../../providers/prayer_provider.dart';
import '../../../repositories/prayer_repository.dart';
import '../../../models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';

class PrayerTrackerScreen extends ConsumerWidget {
  const PrayerTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Tracker',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and subtitle
            Text(
              'Daily Prayers',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32, // Increased from default headlineMedium size
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Track your salah completion throughout the day',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
                fontSize: 18, // Increased from default bodyMedium size
              ),
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

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.lightGreen,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Text(
                'Establishing regular prayer (salah) strengthens your connection with Allah and provides spiritual protection throughout your day.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18, // Increased from default bodyMedium size
                  color: AppTheme.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: AppTheme.spacingXL,
            ), // Add extra spacing at bottom
          ],
        ),
      ),
    );
  }
}
