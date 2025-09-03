import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
          const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: titleStyle ?? Theme.of(context).textTheme.displayLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            subtitle,
            style: subtitleStyle ?? Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingL),
          Text(
            description,
            style: descriptionStyle ?? Theme.of(context).textTheme.bodyLarge,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
