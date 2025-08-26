import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
        ? AppTheme.successGreen
        : trend == 'down'
        ? AppTheme.errorRed
        : AppTheme.mediumGray;

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isSuccess
              ? [
                  AppTheme.successGreen.withValues(alpha: 0.1),
                  AppTheme.successGreen.withValues(alpha: 0.05),
                ]
              : [
                  AppTheme.warningOrange.withValues(alpha: 0.1),
                  AppTheme.warningOrange.withValues(alpha: 0.05),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: isSuccess ? AppTheme.successGreen : AppTheme.warningOrange,
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isSuccess
                ? AppTheme.successGreen.withValues(alpha: 0.2)
                : AppTheme.warningOrange.withValues(alpha: 0.2),
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
                                  ? AppTheme.successGreen
                                  : AppTheme.warningOrange))
                          .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppTheme.radiusM),
                ),
                child: Icon(
                  icon,
                  color:
                      iconColor ??
                      (isSuccess
                          ? AppTheme.successGreen
                          : AppTheme.warningOrange),
                  size: 24,
                ),
              ),
              const SizedBox(width: AppTheme.spacingM),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.darkGreen,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingL),

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
                        color: AppTheme.mediumGray,
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
                                ? AppTheme.successGreen
                                : AppTheme.warningOrange,
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
          const SizedBox(height: AppTheme.spacingM),
          Container(
            height: 8,
            decoration: BoxDecoration(
              color: AppTheme.lightGray,
              borderRadius: BorderRadius.circular(4),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: successRate / 100,
              child: Container(
                decoration: BoxDecoration(
                  color: isSuccess
                      ? AppTheme.successGreen
                      : AppTheme.warningOrange,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ),

          // Performance indicator
          const SizedBox(height: AppTheme.spacingS),
          Text(
            _getPerformanceText(successRate),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: isSuccess ? AppTheme.successGreen : AppTheme.warningOrange,
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
