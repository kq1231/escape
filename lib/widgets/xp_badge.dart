import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class XPBadge extends StatelessWidget {
  final int xpAmount;
  final Color? backgroundColor;
  final Color? textColor;
  final double? fontSize;
  final EdgeInsetsGeometry? padding;
  final double? badgeSize;
  final bool isTotal;

  const XPBadge({
    super.key,
    required this.xpAmount,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
    this.padding,
    this.badgeSize,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    String displayText;
    if (isTotal) {
      displayText = '${_formatXPWithK(xpAmount)} XP';
    } else {
      displayText = ' + ${_formatXPWithK(xpAmount)} ';
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppConstants.white, width: 1.5),
      ),
      child: Badge(
        label: Text(
          displayText,
          style: TextStyle(
            color: textColor ?? AppConstants.white,
            fontSize: fontSize ?? 12, // Increased default size
            fontWeight: FontWeight.bold,
            fontFamily: 'monospace',
          ),
        ),
        backgroundColor: backgroundColor ?? AppConstants.primaryGreen,
        padding:
            padding ??
            const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 4,
            ), // Increased padding
        largeSize: badgeSize ?? 20, // Increased default size
        textStyle: TextStyle(
          color: textColor ?? AppConstants.white,
          fontSize: fontSize ?? 12, // Increased default size
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  String _formatXPWithK(int xp) {
    if (xp >= 1000) {
      return '${(xp / 1000).toStringAsFixed(1)}K';
    }
    return xp.toString();
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
    double? badgeSize,
    bool isTotal = false,
  }) {
    String formatXPWithK(int xp) {
      if (xp >= 1000) {
        return '${(xp / 1000).toStringAsFixed(1)}K';
      }
      return xp.toString();
    }

    String displayText;
    if (isTotal) {
      displayText = '${formatXPWithK(xpAmount)} XP ';
    } else {
      displayText = ' + ${formatXPWithK(xpAmount)} ';
    }

    final badgedWidget = Stack(
      clipBehavior: Clip.none,
      children: [
        this,
        Positioned(
          top: -8,
          right: -8,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(99),
              border: Border.all(color: AppConstants.white, width: 1.5),
            ),
            child: Badge(
              label: Text(
                displayText,
                style: TextStyle(
                  color: badgeTextColor ?? AppConstants.white,
                  fontSize: badgeFontSize ?? 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'monospace',
                ),
              ),
              backgroundColor: badgeColor ?? AppConstants.primaryGreen,
              largeSize: badgeSize ?? 20,
            ),
          ),
        ),
      ],
    );

    return expanded ? Expanded(child: badgedWidget) : badgedWidget;
  }
}
