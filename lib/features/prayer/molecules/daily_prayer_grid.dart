import 'package:flutter/material.dart';
import '../molecules/prayer_row.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/prayer_model.dart';
import '../atoms/triple_state_checkbox.dart';

class DailyPrayerGrid extends StatelessWidget {
  final List<Prayer> prayers;
  final Function(Prayer, CheckboxState)? onPrayerStateChanged;
  final VoidCallback? onPrayerTap;

  const DailyPrayerGrid({
    super.key,
    required this.prayers,
    this.onPrayerStateChanged,
    this.onPrayerTap,
  });

  @override
  Widget build(BuildContext context) {
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
            ? Theme.of(context).colorScheme.surface
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
                style: Theme.of(
                  context,
                ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
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
                  onStateChanged: onPrayerStateChanged != null
                      ? (state) => onPrayerStateChanged!(
                          prayer ??
                              Prayer(
                                name: prayerName,
                                isCompleted: state == CheckboxState.checked,
                              ),
                          state,
                        )
                      : null,
                  onTap: onPrayerTap,
                ),
                if (prayerName != prayerNames.last)
                  const SizedBox(height: AppTheme.spacingS),
              ],
            );
          }),
        ],
      ),
    );
  }
}
