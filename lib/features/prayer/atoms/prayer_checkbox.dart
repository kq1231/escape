import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class PrayerCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final double size;

  const PrayerCheckbox({
    super.key,
    this.isChecked = false,
    this.onChanged,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isChecked
              ? OnboardingTheme.primaryGreen
              : OnboardingTheme.white,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusS),
          border: Border.all(
            color: isChecked
                ? OnboardingTheme.primaryGreen
                : OnboardingTheme.mediumGray,
            width: 2.0,
          ),
        ),
        child: isChecked
            ? Icon(Icons.check, size: size * 0.7, color: OnboardingTheme.white)
            : null,
      ),
    );
  }
}
