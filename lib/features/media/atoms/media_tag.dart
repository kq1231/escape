import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class MediaTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final IconData? icon;

  const MediaTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? OnboardingTheme.primaryGreen;
    final text = textColor ?? OnboardingTheme.white;

    final tagChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: text),
          SizedBox(width: OnboardingTheme.spacingXS),
        ],
        Text(label, style: OnboardingTheme.labelMedium.copyWith(color: text)),
      ],
    );

    final tag = Container(
      padding: EdgeInsets.symmetric(
        horizontal: OnboardingTheme.spacingM,
        vertical: OnboardingTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
      ),
      child: tagChild,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: tag);
    }

    return tag;
  }
}
