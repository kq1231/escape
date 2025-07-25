import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class RelapseButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const RelapseButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonColor = backgroundColor ?? OnboardingTheme.errorRed;
    final textColor = foregroundColor ?? OnboardingTheme.white;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      foregroundColor: textColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
      ),
      padding:
          padding ??
          EdgeInsets.symmetric(
            horizontal: OnboardingTheme.spacingXL,
            vertical: OnboardingTheme.spacingM,
          ),
    );

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 20),
          SizedBox(width: OnboardingTheme.spacingS),
        ],
        Text(text, style: OnboardingTheme.labelLarge),
      ],
    );

    final button = ElevatedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: buttonChild,
    );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
