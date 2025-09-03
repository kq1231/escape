import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class ChallengeProgressBar extends StatelessWidget {
  final double progress; // Value between 0.0 and 1.0
  final double height;
  final Color? backgroundColor;
  final Color? progressColor;
  final BorderRadius? borderRadius;
  final String? leadingText;
  final String? trailingText;
  final TextStyle? textStyle;

  const ChallengeProgressBar({
    super.key,
    required this.progress,
    this.height = 8.0,
    this.backgroundColor,
    this.progressColor,
    this.borderRadius,
    this.leadingText,
    this.trailingText,
    this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    final clampedProgress = progress.clamp(0.0, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (leadingText != null || trailingText != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leadingText != null)
                Text(
                  leadingText!,
                  style: textStyle ?? Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              if (trailingText != null)
                Text(
                  trailingText!,
                  style: textStyle ?? Theme.of(context).textTheme.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        if (leadingText != null || trailingText != null)
          const SizedBox(height: AppConstants.spacingXS),
        ClipRRect(
          borderRadius:
              borderRadius ?? BorderRadius.circular(AppConstants.radiusM),
          child: Container(
            height: height,
            color: backgroundColor ?? AppConstants.lightGray,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    // Progress fill
                    Container(
                      width: constraints.maxWidth * clampedProgress,
                      color: progressColor ?? AppConstants.primaryGreen,
                    ),
                    // Animated progress (optional visual enhancement)
                    if (clampedProgress > 0)
                      Positioned(
                        left: 0,
                        right: constraints.maxWidth * (1 - clampedProgress),
                        child: Container(
                          height: height,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                (progressColor ?? AppConstants.primaryGreen)
                                    .withValues(alpha: 0.3),
                                (progressColor ?? AppConstants.primaryGreen)
                                    .withValues(alpha: 0.1),
                              ],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
