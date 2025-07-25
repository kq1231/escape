import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = backgroundColor ?? OnboardingTheme.white;
    final textColor = OnboardingTheme.darkGray;
    final iconColorValue = iconColor ?? OnboardingTheme.primaryGreen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OnboardingTheme.spacingM),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
          boxShadow: OnboardingTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColorValue, size: 24),
              const SizedBox(height: OnboardingTheme.spacingS),
            ],
            Text(
              title,
              style: OnboardingTheme.bodyMedium.copyWith(
                color: textColor.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: OnboardingTheme.spacingXS),
            Text(
              value,
              style: OnboardingTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: OnboardingTheme.spacingXS),
              Text(
                subtitle!,
                style: OnboardingTheme.bodySmall.copyWith(
                  color: textColor.withValues(alpha: 0.6),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
