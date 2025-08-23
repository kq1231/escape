import 'package:escape/providers/prayer_provider.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../molecules/prayer_row.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';

class DailyPrayerGrid extends ConsumerWidget {
  final Function(Prayer, CheckboxState)? onPrayerStateChanged;
  final VoidCallback? onPrayerTap;

  const DailyPrayerGrid({
    super.key,
    this.onPrayerStateChanged,
    this.onPrayerTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());

    return todaysPrayersAsync.when(
      data: (prayers) {
        // List of the 5 daily prayers in order
        final List<String> prayerNames = [
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

        return Container(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.black
                : AppTheme.white,
            borderRadius: BorderRadius.circular(AppTheme.radiusL),
            border: Border.all(color: AppTheme.lightGray),
            boxShadow: AppTheme.cardShadow,
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
                  Text(
                    '$completedCount/${prayerNames.length}',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.primaryGreen,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Prayer rows
              ...prayerNames.map((prayerName) {
                final prayer = prayerMap[prayerName];
                return Column(
                  children: [
                    PrayerRow(
                      prayerName: prayerName,
                      prayer: prayer,
                      onStateChanged: (state) {
                        // Handle prayer state changes
                        switch (state) {
                          case CheckboxState.checked:
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
                            if (prayer!.id != 0) {
                              ref
                                  .read(prayerRepositoryProvider.notifier)
                                  .deletePrayer(prayer.id);
                            }
                            break;
                        }
                      },
                      onTap: () {
                        onPrayerTap?.call();
                      },
                    ),
                    if (prayerName != prayerNames.last)
                      const SizedBox(height: AppTheme.spacingS),
                  ],
                );
              }),
            ],
          ),
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Text('Error: $error'),
    );
  }
}
