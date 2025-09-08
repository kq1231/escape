import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class SuccessRateCard extends StatelessWidget {
  final double successRate;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color? iconColor;
  final String? trend;
  final bool showPercentage;

  const SuccessRateCard({
    super.key,
    required this.successRate,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.iconColor,
    this.trend,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final displayValue = showPercentage
        ? '${successRate.round()}%'
        : successRate.round().toString();
    final isSuccess = successRate >= 70;
    final trendColor = trend == 'up'
        ? AppConstants.successGreen
        : trend == 'down'
        ? AppConstants.errorRed
        : AppConstants.mediumGray;

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSuccess
              ? [
                  AppConstants.successGreen.withValues(alpha: 0.1),
                  AppConstants.successGreen.withValues(alpha: 0.05),
                ]
              : [
                  AppConstants.warningOrange.withValues(alpha: 0.1),
                  AppConstants.warningOrange.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
        border: Border.all(
          color: isSuccess
              ? AppConstants.successGreen
              : AppConstants.warningOrange,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSuccess
                ? AppConstants.successGreen.withValues(alpha: 0.2)
                : AppConstants.warningOrange.withValues(alpha: 0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with icon and title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color:
                      (iconColor ??
                              (isSuccess
                                  ? AppConstants.successGreen
                                  : AppConstants.warningOrange))
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
                child: Icon(
                  icon,
                  color:
                      iconColor ??
                      (isSuccess
                          ? AppConstants.successGreen
                          : AppConstants.warningOrange),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppConstants.darkGreen,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingL),

          // Success rate display
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Success Rate',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppConstants.mediumGray,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      displayValue,
                      style: Theme.of(context).textTheme.displayMedium
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isSuccess
                                ? AppConstants.successGreen
                                : AppConstants.warningOrange,
                            fontSize: 36,
                          ),
                    ),
                  ],
                ),
              ),

              // Trend indicator
              if (trend != null)
                Column(
                  children: [
                    Icon(
                      trend == 'up' ? Icons.trending_up : Icons.trending_down,
                      color: trendColor,
                      size: 20,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      trend == 'up' ? 'Improving' : 'Declining',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: trendColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Progress bar
          const SizedBox(height: AppConstants.spacingM),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppConstants.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: successRate / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: isSuccess
                      ? AppConstants.successGreen
                      : AppConstants.warningOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Performance indicator
          const SizedBox(height: AppConstants.spacingS),
          Text(
            _getPerformanceText(successRate),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSuccess
                  ? AppConstants.successGreen
                  : AppConstants.warningOrange,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _getPerformanceText(double rate) {
    if (rate >= 90) return 'Excellent! Keep it up! 🌟';
    if (rate >= 80) return 'Great job! Very consistent! 👏';
    if (rate >= 70) return 'Good progress! Keep improving! 💪';
    if (rate >= 60) return 'Not bad, room for improvement! 📈';
    if (rate >= 50) return 'Keep trying, you can do better! 🎯';
    return 'Stay motivated, progress takes time! 💫';
  }
}
