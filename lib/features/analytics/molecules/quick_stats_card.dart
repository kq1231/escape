import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class QuickStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final IconData? icon;
  final Color? iconColor;
  final Color? backgroundColor;
  const QuickStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.icon,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? const Color(0xFF1E1E1E)
            : AppConstants.white);
    final textColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : AppConstants.darkGray;
    final iconColorValue = iconColor ?? AppConstants.primaryGreen;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        boxShadow: AppConstants.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (icon != null) ...[
            Icon(icon, color: iconColorValue, size: 24),
            const SizedBox(height: AppConstants.spacingS),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor.withValues(alpha: 0.8),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          const SizedBox(height: AppConstants.spacingXS),
          Text(
            value,
            style: Theme.of(context).textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColor,
              fontSize: 26,
            ),
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppConstants.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: textColor.withValues(alpha: 0.6),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
