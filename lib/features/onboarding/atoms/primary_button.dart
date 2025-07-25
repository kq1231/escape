import 'package:flutter/material.dart';
import '../constants/onboarding_theme.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Widget? icon;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const PrimaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.icon,
    this.width,
    this.height,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            foregroundColor: OnboardingTheme.primaryGreen,
            side: const BorderSide(color: OnboardingTheme.primaryGreen),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
            ),
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: OnboardingTheme.spacingXL,
                  vertical: OnboardingTheme.spacingM,
                ),
            textStyle: OnboardingTheme.labelLarge,
          )
        : ElevatedButton.styleFrom(
            backgroundColor: OnboardingTheme.primaryGreen,
            foregroundColor: OnboardingTheme.white,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
            ),
            padding:
                padding ??
                const EdgeInsets.symmetric(
                  horizontal: OnboardingTheme.spacingXL,
                  vertical: OnboardingTheme.spacingM,
                ),
            textStyle: OnboardingTheme.labelLarge,
          );

    final buttonChild = isLoading
        ? const SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                icon!,
                const SizedBox(width: OnboardingTheme.spacingS),
              ],
              Text(text),
            ],
          );

    final button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: buttonChild,
          );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height, child: button);
    }

    return button;
  }
}
