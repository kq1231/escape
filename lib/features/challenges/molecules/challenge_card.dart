import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/challenge_badge.dart';
import '../atoms/challenge_star.dart';
import '../atoms/progress_bar.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final double rating;
  final int maxRating;
  final bool isCompleted;
  final String? difficulty;
  final VoidCallback? onTap;
  final Widget? leadingWidget;
  final List<Widget>? trailingWidgets;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    this.progress = 0.0,
    this.rating = 0.0,
    this.maxRating = 5,
    this.isCompleted = false,
    this.difficulty,
    this.onTap,
    this.leadingWidget,
    this.trailingWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isCompleted
        ? AppTheme.successGreen
        : progress > 0
        ? AppTheme.warningOrange
        : AppTheme.mediumGray;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with leading widget, title, and trailing widgets
              Row(
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget!,
                    const SizedBox(width: AppTheme.spacingS),
                  ] else
                    ChallengeBadge(
                      title: title.substring(0, 1),
                      isCompleted: isCompleted,
                      size: 40,
                    ),
                  const SizedBox(width: AppTheme.spacingS),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        color: isCompleted
                            ? AppTheme.successGreen
                            : AppTheme.darkGray,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailingWidgets != null) ...[
                    const SizedBox(width: AppTheme.spacingS),
                    ...trailingWidgets!,
                  ] else if (difficulty != null) ...[
                    const SizedBox(width: AppTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        difficulty!,
                        style: Theme.of(
                          context,
                        ).textTheme.labelMedium?.copyWith(color: statusColor),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: AppTheme.spacingS),
              // Description
              Flexible(
                child: Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Progress bar
              ChallengeProgressBar(
                progress: progress,
                leadingText: 'Progress',
                trailingText: '${(progress * 100).round()}%',
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Rating and badges section
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ChallengeStar(rating: rating, maxRating: maxRating, size: 18),
                  const SizedBox(height: AppTheme.spacingS),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppTheme.successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: AppTheme.spacingXS),
                          Text(
                            'Completed',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppTheme.successGreen),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
