import 'package:flutter/material.dart';
import '../atoms/streak_number.dart';
import '../atoms/streak_label.dart';
import '../atoms/streak_icon.dart';
import '../../../theme/app_theme.dart';

class StreakCard extends StatelessWidget {
  final int streakCount;
  final String labelText;
  final VoidCallback? onTap;
  final bool isActive;

  const StreakCard({
    super.key,
    required this.streakCount,
    this.labelText = 'Days Clean',
    this.onTap,
    this.isActive = true,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusXL),
          boxShadow: AppTheme.cardShadow,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                StreakIcon(isActive: isActive, size: 28),
                const SizedBox(width: AppTheme.spacingS),
                StreakNumber(streakCount: streakCount, fontSize: 36),
              ],
            ),
            const SizedBox(height: AppTheme.spacingS),
            StreakLabel(text: labelText, fontSize: 16),
          ],
        ),
      ),
    );
  }
}
