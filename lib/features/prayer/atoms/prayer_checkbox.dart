import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class PrayerCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool>? onChanged;
  final double size;

  const PrayerCheckbox({
    super.key,
    this.isChecked = false,
    this.onChanged,
    this.size = 24.0,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onChanged != null ? () => onChanged!(!isChecked) : null,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: isChecked
              ? AppTheme.primaryGreen
              : (Theme.of(context).brightness == Brightness.dark
                    ? const Color(0xFF2A2A2A)
                    : AppTheme.white),
          borderRadius: BorderRadius.circular(AppTheme.radiusS),
          border: Border.all(
            color: isChecked
                ? AppTheme.primaryGreen
                : (Theme.of(context).brightness == Brightness.dark
                      ? AppTheme.mediumGray
                      : AppTheme.mediumGray),
            width: 3.0, // Made outline more pronounced
          ),
        ),
        child: isChecked
            ? Icon(Icons.check, size: size * 0.7, color: AppTheme.white)
            : null,
      ),
    );
  }
}
