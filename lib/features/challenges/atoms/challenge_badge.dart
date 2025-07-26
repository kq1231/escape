import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class ChallengeBadge extends StatelessWidget {
  final String title;
  final String? subtitle;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final bool isCompleted;
  final double size;
  final VoidCallback? onTap;

  const ChallengeBadge({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.isCompleted = false,
    this.size = 60.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final badgeColor = isCompleted
        ? backgroundColor ?? AppTheme.successGreen
        : backgroundColor ?? AppTheme.lightGray;

    final textColor = isCompleted ? AppTheme.white : AppTheme.darkGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: badgeColor,
          shape: BoxShape.circle,
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(icon, color: iconColor ?? textColor, size: size * 0.4),
            if (icon != null && subtitle != null)
              const SizedBox(height: AppTheme.spacingXS),
            Text(
              title,
              style: AppTheme.labelMedium.copyWith(
                color: textColor,
                fontWeight: isCompleted ? FontWeight.bold : FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
