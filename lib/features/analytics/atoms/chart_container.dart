import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class ChartContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const ChartContainer({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OnboardingTheme.spacingM),
        decoration: BoxDecoration(
          color: OnboardingTheme.white,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
          boxShadow: OnboardingTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: OnboardingTheme.headlineSmall.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: OnboardingTheme.spacingXS),
            ],
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: OnboardingTheme.bodySmall.copyWith(
                  color: OnboardingTheme.mediumGray,
                ),
              ),
              const SizedBox(height: OnboardingTheme.spacingM),
            ] else if (title != null) ...[
              const SizedBox(height: OnboardingTheme.spacingM),
            ],
            Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }
}
