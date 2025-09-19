import 'package:escape/models/timings_model.dart';
import 'package:escape/models/xp_history_item_model.dart';
import 'package:escape/providers/prayer_provider.dart';
import 'package:escape/providers/prayer_timing_provider.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/providers/xp_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../molecules/prayer_row.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';
import '../../history/screens/prayer_history_screen.dart';

class DailyPrayerGrid extends ConsumerWidget {
  final Function(Prayer, CheckboxState)? onPrayerStateChanged;
  final VoidCallback? onPrayerTap;
  const DailyPrayerGrid({
    super.key,
    this.onPrayerStateChanged,
    this.onPrayerTap,
  });
  // Helper method to get XP amount for different prayers
  int _getXPForPrayer(String prayerName) {
    switch (prayerName) {
      case 'Fajr':
        return 300;
      case 'Asr':
        return 300;
      case 'Tahajjud':
        return 5000;
      case 'Dhuhr':
      case 'Maghrib':
      case 'Isha':
        return 100;
      default:
        return 100;
    }
  }

  // Helper method to get prayer time from PrayerTimes
  String? _getPrayerTime(String prayerName, PrayerTimes? prayerTimes) {
    if (prayerTimes == null) return null;

    switch (prayerName) {
      case 'Fajr':
        return prayerTimes.timings.fajr;
      case 'Dhuhr':
        return prayerTimes.timings.dhuhr;
      case 'Asr':
        return prayerTimes.timings.asr;
      case 'Maghrib':
        return prayerTimes.timings.maghrib;
      case 'Isha':
        return prayerTimes.timings.isha;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());
    final prayerTimingAsync = ref.watch(prayerTimingProvider);

    return todaysPrayersAsync.when(
      data: (prayers) {
        // List of the 5 daily prayers in order
        final List<String> prayerNames = [
          'Tahajjud',
          'Fajr',
          'Dhuhr',
          'Asr',
          'Maghrib',
          'Isha',
        ];
        // Create a map of prayers by name for easy lookup
        final Map<String, Prayer> prayerMap = {
          for (var prayer in prayers) prayer.name: prayer,
        };
        // Count completed prayers
        final int completedCount = prayers
            .where((prayer) => prayer.isCompleted)
            .length;

        // Check if we need to show retry button
        bool showRetryButton = false;
        PrayerTimes? prayerTimes;

        if (prayerTimingAsync is AsyncData) {
          prayerTimes = prayerTimingAsync.value;
        } else if (prayerTimingAsync is AsyncError) {
          showRetryButton = true;
        }

        return Container(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppConstants.black
                : AppConstants.white,
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            border: Border.all(color: AppConstants.lightGray),
            boxShadow: AppConstants.cardShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Today\'s Prayers',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        '$completedCount/${prayerNames.length}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppConstants.primaryGreen,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(width: AppConstants.spacingS),
                      IconButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PrayerHistoryScreen(),
                            ),
                          );
                        },
                        icon: const Icon(Icons.history),
                        tooltip: 'View Prayer History',
                        iconSize: 20,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),
              // Prayer rows
              ...prayerNames.map((prayerName) {
                final prayer = prayerMap[prayerName];
                // Skip timing for Tahajjud
                if (prayerName == 'Tahajjud') {
                  return Column(
                    children: [
                      PrayerRow(
                        prayerName: prayerName,
                        xp: _getXPForPrayer(prayerName),
                        prayer: prayer,
                        onStateChanged: (state) async {
                          await _handlePrayerStateChange(
                            prayerName,
                            prayer,
                            state,
                            ref,
                            context,
                          );
                        },
                        onTap: () {
                          onPrayerTap?.call();
                        },
                      ),
                      if (prayerName != prayerNames.last)
                        const SizedBox(height: AppConstants.spacingS),
                    ],
                  );
                }
                // For other prayers, include timing if available
                return Column(
                  children: [
                    PrayerRow(
                      prayerName: prayerName,
                      prayer: prayer,
                      xp: _getXPForPrayer(prayerName),
                      time: _getPrayerTime(prayerName, prayerTimes),
                      onStateChanged: (state) async {
                        await _handlePrayerStateChange(
                          prayerName,
                          prayer,
                          state,
                          ref,
                          context,
                        );
                      },
                      onTap: () {
                        onPrayerTap?.call();
                      },
                    ),
                    if (prayerName != prayerNames.last)
                      const SizedBox(height: AppConstants.spacingS),
                  ],
                );
              }),
              // Show retry button if needed
              if (showRetryButton) ...[
                const SizedBox(height: AppConstants.spacingM),
                ElevatedButton.icon(
                  onPressed: () {
                    ref.invalidate(prayerTimingProvider);
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry Loading Prayer Times'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 40),
                  ),
                ),
              ],
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }

  Future<void> _handlePrayerStateChange(
    String prayerName,
    Prayer? prayer,
    CheckboxState state,
    WidgetRef ref,
    BuildContext context,
  ) async {
    // Handle prayer state changes
    switch (state) {
      case CheckboxState.checked:
        // Award XP based on prayer type
        int xpAmount = _getXPForPrayer(prayerName);
        // Award XP first
        XPHistoryItem xpHistoryItem = await ref
            .read(xPControllerProvider.notifier)
            .createXP(
              xpAmount,
              'Completed $prayerName prayer',
              context: context,
            );
        // Create or update prayer as completed
        if (prayer == null) {
          // Create new prayer
          final newPrayer = Prayer(
            name: prayerName,
            isCompleted: true,
            date: DateTime(
              DateTime.now().year,
              DateTime.now().month,
              DateTime.now().day,
            ),
          )..xpHistory.target = xpHistoryItem;
          ref.read(prayerRepositoryProvider.notifier).createPrayer(newPrayer);
        } else {
          // Update existing prayer
          final updatedPrayer = prayer.copyWith(isCompleted: true);
          ref
              .read(prayerRepositoryProvider.notifier)
              .updatePrayer(updatedPrayer);
        }
        break;
      case CheckboxState.unchecked:
        // Create or update prayer as not completed and reverse XP
        if (prayer!.id == 0) {
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
          ref.read(prayerRepositoryProvider.notifier).createPrayer(newPrayer);
        } else {
          // Update existing prayer and reverse XP
          final updatedPrayer = prayer.copyWith(isCompleted: false);
          ref
              .read(prayerRepositoryProvider.notifier)
              .updatePrayer(updatedPrayer);
          // Reverse XP when prayer is unmarked
          await ref
              .read(xPControllerProvider.notifier)
              .deleteXPOfPrayer(prayer, context: context);
        }
        break;
      case CheckboxState.empty:
        // Delete prayer if it exists
        if (prayer!.id != 0) {
          ref.read(prayerRepositoryProvider.notifier).deletePrayer(prayer.id);
        }
        break;
    }
  }
}
