import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        backgroundColor ??
        (Theme.of(context).brightness == Brightness.dark
            ? AppConstants.darkGreen
            : AppConstants.primaryGreen);
    final color = iconColor ?? AppConstants.white;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: AppConstants.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                content,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 14,
                  color: AppConstants.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
