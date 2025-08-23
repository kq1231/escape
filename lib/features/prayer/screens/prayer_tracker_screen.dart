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
            DailyPrayerGrid(),

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
