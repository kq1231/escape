import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class ChallengeBadge extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isCompleted;
  final double size;
  final VoidCallback? onTap;

  const ChallengeBadge({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.isCompleted = false,
    this.size = 60.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isCompleted
        ? backgroundColor ?? OnboardingTheme.successGreen
        : backgroundColor ?? OnboardingTheme.lightGray;

    final textColor = isCompleted
        ? OnboardingTheme.white
        : OnboardingTheme.darkGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
          boxShadow: OnboardingTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: iconColor ?? textColor, size: size * 0.4),
            if (icon != null && subtitle != null)
              const SizedBox(height: OnboardingTheme.spacingXS),
            Text(
              title,
              style: OnboardingTheme.labelMedium.copyWith(
                color: textColor,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.normal,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
