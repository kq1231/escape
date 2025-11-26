import 'package:escape/features/history/screens/prayer_history_screen.dart';
import 'package:escape/features/prayer/molecules/NextPrayerCard.dart';
import 'package:escape/features/prayer/molecules/daily_prayer_grid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/providers/prayer_timing_provider.dart'; // Make sure you have this

class PrayerTrackerScreen extends ConsumerWidget {
  const PrayerTrackerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final prayerTimingAsync = ref.watch(prayerTimingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingXL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- HEADER ----------------
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Positioned(
                    right: 0,
                    top: -30,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppConstants.primaryGreen.withOpacity(0.1),
                          width: 2,
                        ),
                      ),
                      child: CircleAvatar(
                        radius: 27,
                        backgroundColor: AppConstants.primaryGreen,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const PrayerHistoryScreen(),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              'assets/history_icon.png',
                              fit: BoxFit.contain,
                              color: AppConstants.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        'Daily Prayers',
                        style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Exo',
                              fontSize: 35,
                            ),
                      ),
                      Image.asset(
                        "assets/prayer.png",
                        height: 80,
                        width: 80,
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                'Track your salah completion throughout the day',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppConstants.mediumGray,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // ---------------- NEXT PRAYER ----------------
              prayerTimingAsync.when(
                data: (prayerTimes) {
                  return NextPrayerCard(
                    todayPrayerTimes: {
                      'Fajr': prayerTimes!.timings.fajr,
                      'Dhuhr': prayerTimes.timings.dhuhr,
                      'Asr': prayerTimes.timings.asr,
                      'Maghrib': prayerTimes.timings.maghrib,
                      'Isha': prayerTimes.timings.isha,
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => const Text('Error loading prayer times'),
              ),

              const SizedBox(height: 30),

              DailyPrayerGrid(),

              const SizedBox(height: AppConstants.spacingXL),

            

            ],
          ),
        ),
      ),
    );
  }
}
