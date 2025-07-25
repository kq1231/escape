import 'package:flutter/material.dart';
import '../constants/onboarding_theme.dart';

class WelcomeText extends StatelessWidget {
  final String title;
  final String subtitle;
  final String description;
  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;
  final TextStyle? descriptionStyle;
  final EdgeInsetsGeometry? padding;

  const WelcomeText({
    super.key,
    required this.title,
    required this.subtitle,
    required this.description,
    this.titleStyle,
    this.subtitleStyle,
    this.descriptionStyle,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ??
          const EdgeInsets.symmetric(horizontal: OnboardingTheme.spacingXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: titleStyle ?? OnboardingTheme.headlineLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: OnboardingTheme.spacingS),
          Text(
            subtitle,
            style: subtitleStyle ?? OnboardingTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: OnboardingTheme.spacingL),
          Text(
            description,
            style: descriptionStyle ?? OnboardingTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
