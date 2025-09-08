import 'package:escape/theme/app_constants.dart';
import 'package:flutter/material.dart';

class ChartContainer extends StatelessWidget {
  final Widget child;
  final String? title;
  final String? subtitle;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;

  const ChartContainer({
    super.key,
    required this.child,
    this.title,
    this.subtitle,
    this.onTap,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppConstants.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: AppConstants.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (title != null) ...[
              Text(
                title!,
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 26, // Increased from default headlineSmall size
                ),
              ),
              const SizedBox(height: AppConstants.spacingXS),
            ],
            if (subtitle != null) ...[
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.mediumGray,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
            ] else if (title != null) ...[
              const SizedBox(height: AppConstants.spacingM),
            ],
            Padding(padding: padding ?? EdgeInsets.zero, child: child),
          ],
        ),
      ),
    );
  }
}
