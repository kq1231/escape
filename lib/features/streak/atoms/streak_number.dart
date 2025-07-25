import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class StreakNumber extends StatelessWidget {
  final int streakCount;
  final Color? color;
  final double? fontSize;

  const StreakNumber({
    super.key,
    required this.streakCount,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$streakCount',
      style: OnboardingTheme.headlineLarge.copyWith(
        fontSize: fontSize ?? 48,
        fontWeight: FontWeight.bold,
        color: color ?? OnboardingTheme.primaryGreen,
      ),
    );
  }
}
