import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class StreakIcon extends StatelessWidget {
  final Color? color;
  final double? size;
  final bool isActive;

  const StreakIcon({super.key, this.color, this.size, this.isActive = true});

  @override
  Widget build(BuildContext context) {
    return Icon(
      Icons.local_fire_department,
      color:
          color ??
          (isActive
              ? OnboardingTheme.primaryGreen
              : OnboardingTheme.mediumGray),
      size: size ?? 32,
    );
  }
}
