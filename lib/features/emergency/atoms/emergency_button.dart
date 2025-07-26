import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
    final buttonColor = backgroundColor ?? Colors.redAccent;
    final textColor = foregroundColor ?? Colors.white;

    final buttonStyle = ElevatedButton.styleFrom(
      backgroundColor: buttonColor,
      foregroundColor: textColor,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: AppTheme.spacingXL,
            vertical: AppTheme.spacingM,
          ),
    );

    final buttonChild = Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 24), // Increased from 20 to 24
          const SizedBox(width: AppTheme.spacingS),
        ],
        Text(
          text,
          style: AppTheme.labelLarge.copyWith(fontWeight: FontWeight.bold),
        ),
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
