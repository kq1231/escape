import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class XPBadge extends StatelessWidget {
  final int xpAmount;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? badgeSize; // Add this parameter

  const XPBadge({
    super.key,
    required this.xpAmount,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.badgeSize, // Add this parameter
  });

  @override
  Widget build(BuildContext context) {
    return Badge(
      label: Text(
        '+$xpAmount',
        style: TextStyle(
          color: textColor ?? AppTheme.white,
          fontSize: fontSize ?? 12, // Increased default size
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      backgroundColor: backgroundColor ?? AppTheme.primaryGreen,
      padding:
          padding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ), // Increased padding
      largeSize: badgeSize ?? 20, // Increased default size
      textStyle: TextStyle(
        color: textColor ?? AppTheme.white,
        fontSize: fontSize ?? 12, // Increased default size
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

/// Extension method to add XP badge to any widget
extension XPBadgeExtension on Widget {
  Widget withXPBadge({
    required int xpAmount,
    Color? badgeColor,
    Color? badgeTextColor,
    double? badgeFontSize,
    EdgeInsetsGeometry? badgePadding,
    bool expanded = false,
    double? badgeSize, // Add this parameter
  }) {
    final badge = Badge(
      label: Text(
        '+$xpAmount',
        style: TextStyle(
          color: badgeTextColor ?? AppTheme.white,
          fontSize: badgeFontSize ?? 12, // Increased default
          fontWeight: FontWeight.bold,
          fontFamily: 'monospace',
        ),
      ),
      backgroundColor: badgeColor ?? AppTheme.primaryGreen,
      padding:
          badgePadding ??
          const EdgeInsets.symmetric(
            horizontal: 8,
            vertical: 4,
          ), // Increased padding
      largeSize: badgeSize ?? 20, // Increased default size
      child: this,
    );

    return expanded ? Expanded(child: badge) : badge;
  }
}
