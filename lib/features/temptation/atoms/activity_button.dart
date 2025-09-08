import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class ActivityButton extends StatelessWidget {
  final String activity;
  final IconData? icon;
  final bool isSelected;
  final VoidCallback? onPressed;
  final Color? backgroundColor;
  final Color? selectedColor;

  const ActivityButton({
    super.key,
    required this.activity,
    this.icon,
    this.isSelected = false,
    this.onPressed,
    this.backgroundColor,
    this.selectedColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onPressed,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
          horizontal: AppConstants.spacingL,
          vertical: AppConstants.spacingM,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? (selectedColor ?? AppConstants.primaryGreen)
              : (backgroundColor ??
                    (isDarkMode
                        ? AppConstants.primaryGreen.withValues(alpha: 0.1)
                        : AppConstants.lightGreen.withValues(alpha: 0.3))),
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(
            color: isSelected
                ? (selectedColor ?? AppConstants.primaryGreen)
                : (isDarkMode
                      ? Colors.white.withValues(alpha: 0.3)
                      : AppConstants.mediumGray.withValues(alpha: 0.5)),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppConstants.primaryGreen.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 24,
                color: isSelected
                    ? AppConstants.white
                    : (isDarkMode ? Colors.white70 : AppConstants.darkGreen),
              ),
              const SizedBox(width: AppConstants.spacingS),
            ],
            Text(
              activity,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                color: isSelected
                    ? AppConstants.white
                    : (isDarkMode ? Colors.white70 : AppConstants.darkGreen),
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
