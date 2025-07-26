import 'package:flutter/material.dart';
import '../molecules/prayer_row.dart';
import 'package:escape/theme/app_theme.dart';

class DailyPrayerGrid extends StatelessWidget {
  final Map<String, bool> prayerStatus;
  final Function(String, bool)? onPrayerStatusChanged;

  const DailyPrayerGrid({
    super.key,
    required this.prayerStatus,
    this.onPrayerStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    // List of the 5 daily prayers in order
    final List<String> prayers = ['Fajr', 'Dhuhr', 'Asr', 'Maghrib', 'Isha'];

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingM),
      decoration: BoxDecoration(
        color: AppTheme.white,
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
                style: AppTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${_getCompletedCount()}/${prayers.length}',
                style: AppTheme.bodyMedium.copyWith(
                  color: AppTheme.primaryGreen,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Prayer rows
          ...prayers.map((prayerName) {
            return Column(
              children: [
                PrayerRow(
                  prayerName: prayerName,
                  isChecked: prayerStatus[prayerName] ?? false,
                  onCheckedChanged: (isChecked) {
                    if (onPrayerStatusChanged != null) {
                      onPrayerStatusChanged!(prayerName, isChecked);
                    }
                  },
                ),
                if (prayerName != prayers.last)
                  const SizedBox(height: AppTheme.spacingS),
              ],
            );
          }),
        ],
      ),
    );
  }

  int _getCompletedCount() {
    return prayerStatus.values.where((status) => status).length;
  }
}
