import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class ProgressIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final double progress;
  final bool showDots;
  final bool showBar;
  final Color activeColor;
  final Color inactiveColor;
  final double dotSize;
  final double spacing;

  const ProgressIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.progress = 0.0,
    this.showDots = true,
    this.showBar = true,
    this.activeColor = Colors.transparent,
    this.inactiveColor = Colors.transparent,
    this.dotSize = 12.0,
    this.spacing = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final active = activeColor == Colors.transparent
        ? AppConstants.primaryGreen
        : activeColor;
    final inactive = inactiveColor == Colors.transparent
        ? AppConstants.mediumGray
        : inactiveColor;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (showBar)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXL,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: LinearProgressIndicator(
                value: progress > 0 ? progress : currentStep / totalSteps,
                backgroundColor: inactive.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(active),
                minHeight: 4,
              ),
            ),
          ),
        if (showDots && showBar) const SizedBox(height: AppConstants.spacingM),
        if (showDots)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(totalSteps, (index) {
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: spacing / 2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: index == currentStep - 1 ? dotSize * 2 : dotSize,
                  height: dotSize,
                  decoration: BoxDecoration(
                    color: index < currentStep ? active : inactive,
                    borderRadius: BorderRadius.circular(dotSize / 2),
                  ),
                ),
              );
            }),
          ),
      ],
    );
  }
}

class CustomCircularProgress extends StatelessWidget {
  final double progress;
  final double size;
  final double strokeWidth;
  final Color progressColor;
  final Color backgroundColor;
  final Widget? child;

  const CustomCircularProgress({
    super.key,
    required this.progress,
    this.size = 120,
    this.strokeWidth = 8,
    this.progressColor = Colors.transparent,
    this.backgroundColor = Colors.transparent,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final active = progressColor == Colors.transparent
        ? AppConstants.primaryGreen
        : progressColor;
    final inactive = backgroundColor == Colors.transparent
        ? AppConstants.mediumGray.withValues(alpha: 0.3)
        : backgroundColor;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: strokeWidth,
              backgroundColor: inactive,
              color: active,
            ),
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
