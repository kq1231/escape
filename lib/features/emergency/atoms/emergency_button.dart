import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class EmergencyButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const EmergencyButton({
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
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final buttonStyle = OutlinedButton.styleFrom(
      side: BorderSide(
        color: isDarkMode ? AppConstants.white : AppConstants.darkGreen,
        width: 2,
      ),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingXL,
            vertical: AppConstants.spacingM,
          ),
    );

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24), // Increased from 20 to 24
          const SizedBox(width: AppConstants.spacingS),
        ],
        Text(
          text,
          style: Theme.of(
            context,
          ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
      ],
    );

    final button = OutlinedButton(
      onPressed: onPressed,
      style: buttonStyle,
      child: buttonChild,
    );

    if (width != null || height != null) {
      return SizedBox(width: width, height: height ?? 60, child: button);
    }

    // If no height or width supplied, set default of 60.
    return SizedBox(height: 60, child: button);
  }
}
