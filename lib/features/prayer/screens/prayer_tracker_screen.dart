import 'package:escape/features/prayer/molecules/daily_prayer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';

class PrayerTrackerScreen extends ConsumerWidget {
  const PrayerTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
        padding: const EdgeInsets.all(AppConstants.spacingXL),
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
            const SizedBox(height: AppConstants.spacingS),
            Text(
              'Track your salah completion throughout the day',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppConstants.mediumGray,
                fontWeight: FontWeight.w500,
                fontSize: 18, // Increased from default bodyMedium size
              ),
            ),
            const SizedBox(height: AppConstants.spacingXL),

            // Prayer grid
            DailyPrayerGrid(),

            const SizedBox(height: AppConstants.spacingXL),

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppConstants.spacingL),
              decoration: BoxDecoration(
                color: AppConstants.lightGreen,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
              ),
              child: Text(
                'Establishing regular prayer (salah) strengthens your connection with Allah and provides spiritual protection throughout your day.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 18, // Increased from default bodyMedium size
                  color: AppConstants.white,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: AppConstants.spacingXL,
            ), // Add extra spacing at bottom
          ],
        ),
      ),
    );
  }
}
