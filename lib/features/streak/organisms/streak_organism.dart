import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StreakOrganism extends StatelessWidget {
  final int streakCount;
  final String labelText;
  final VoidCallback? onTap;
  final bool isActive;

  const StreakOrganism({
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
      child: Container(
        width: double.infinity, // Take full width
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // For larger widths, use row layout with icon on left and text on right
            if (constraints.maxWidth >= 300) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Fire icon with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform:
                        isActive ? Matrix4.identity() : Matrix4.rotationZ(0.1)
                          ..scale(1.2),
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppTheme.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(width: AppTheme.spacingL),
                  // Text content
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Streak count with larger, more prominent text
                        Text(
                          '$streakCount',
                          style: Theme.of(context).textTheme.displayLarge
                              ?.copyWith(
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.white,
                                shadows: [
                                  Shadow(
                                    color: AppTheme.darkGreen.withValues(
                                      alpha: 0.5,
                                    ),
                                    offset: const Offset(2, 2),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        // Label with smaller, but still readable text
                        Text(
                          labelText,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppTheme.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 18,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            } else {
              // For smaller widths, keep the column layout
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Fire icon with animation
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    transform:
                        isActive ? Matrix4.identity() : Matrix4.rotationZ(0.1)
                          ..scale(1.2),
                    child: Icon(
                      Icons.local_fire_department,
                      color: AppTheme.white,
                      size: 40,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  // Streak count with larger, more prominent text
                  Text(
                    '$streakCount',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      fontSize: 48,
                      color: AppTheme.white,
                      shadows: [
                        Shadow(
                          color: AppTheme.darkGreen.withValues(alpha: 0.5),
                          offset: const Offset(2, 2),
                          blurRadius: 4,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingXS),
                  // Label with smaller, but still readable text
                  Text(
                    labelText,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 18,
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
