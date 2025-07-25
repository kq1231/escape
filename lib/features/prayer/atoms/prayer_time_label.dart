import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class PrayerTimeLabel extends StatelessWidget {
  final String prayerName;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;

  const PrayerTimeLabel({
    super.key,
    required this.prayerName,
    this.color,
    this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      prayerName,
      textAlign: textAlign,
      style: OnboardingTheme.headlineSmall.copyWith(
        fontSize: fontSize ?? 18,
        color: color ?? OnboardingTheme.darkGray,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
