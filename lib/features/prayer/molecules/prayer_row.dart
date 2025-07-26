import 'package:flutter/material.dart';
import '../atoms/prayer_checkbox.dart';
import '../atoms/prayer_time_label.dart';
import 'package:escape/theme/app_theme.dart';

class PrayerRow extends StatelessWidget {
  final String prayerName;
  final bool isChecked;
  final ValueChanged<bool>? onCheckedChanged;

  const PrayerRow({
    super.key,
    required this.prayerName,
    this.isChecked = false,
    this.onCheckedChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: AppTheme.white,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        border: Border.all(color: AppTheme.lightGray),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          PrayerTimeLabel(prayerName: prayerName),
          PrayerCheckbox(
            isChecked: isChecked,
            onChanged: onCheckedChanged,
            size: 24.0,
          ),
        ],
      ),
    );
  }
}
