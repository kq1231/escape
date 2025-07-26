import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class StatCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = backgroundColor ?? AppTheme.white;
    final textColor = AppTheme.darkGray;
    final iconColorValue = iconColor ?? AppTheme.primaryGreen;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (icon != null) ...[
              Icon(icon, color: iconColorValue, size: 24),
              const SizedBox(height: AppTheme.spacingS),
            ],
            Text(
              title,
              style: AppTheme.bodyMedium.copyWith(
                color: textColor.withValues(alpha: 0.8),
                fontWeight: FontWeight
                    .w500, // Added medium weight for better readability
                fontSize: 18, // Increased from default bodyMedium size
              ),
            ),
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              value,
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
                color: textColor,
                fontSize: 26, // Increased from default headlineSmall size
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: AppTheme.spacingXS),
              Text(
                subtitle!,
                style: AppTheme.bodySmall.copyWith(
                  color: textColor.withValues(alpha: 0.6),
                  fontWeight: FontWeight
                      .w500, // Added medium weight for better readability
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
