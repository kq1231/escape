import 'package:flutter/material.dart';
import '../atoms/prayer_checkbox.dart';
import '../atoms/prayer_time_label.dart';
import '../../onboarding/constants/onboarding_theme.dart';

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
        horizontal: OnboardingTheme.spacingM,
        vertical: OnboardingTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: OnboardingTheme.white,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
        border: Border.all(color: OnboardingTheme.lightGray),
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
