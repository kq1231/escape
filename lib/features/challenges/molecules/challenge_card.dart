import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';
import '../../../widgets/xp_badge.dart';
import '../atoms/challenge_badge.dart';
import '../atoms/progress_bar.dart';

class ChallengeCard extends StatelessWidget {
  final String title;
  final String description;
  final double progress;
  final double rating;
  final int maxRating;
  final bool isCompleted;
  final String? difficulty;
  final int? xp;
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
    this.xp,
    this.onTap,
    this.leadingWidget,
    this.trailingWidgets,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = isCompleted
        ? AppConstants.successGreen
        : progress > 0
        ? AppConstants.warningOrange
        : AppConstants.mediumGray;

    // Determine if we should show XP badge (only if XP > 0)
    final bool showXpBadge = xp != null && xp! > 0;

    // Determine if we should show difficulty badge (only if difficulty is not empty)
    final bool showDifficultyBadge =
        difficulty != null && difficulty!.isNotEmpty;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          // Use theme-aware color instead of white
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
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
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            // XP Badge at top-right corner (only if XP > 0)
            if (showXpBadge)
              Positioned(
                top: -5,
                right: -5,
                child: XPBadge(
                  backgroundColor: isCompleted
                      ? AppConstants.successGreen
                      : Colors.orange[700]!,
                  textColor: AppConstants.white,
                  xpAmount: xp!,
                ),
              ),
            // Main card content
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingM),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header row with leading widget and trailing widgets
                  Row(
                    children: [
                      if (leadingWidget != null) ...[
                        leadingWidget!,
                        const SizedBox(width: AppConstants.spacingS),
                      ] else
                        ChallengeBadge(
                          title: title.substring(0, 1),
                          isCompleted: isCompleted,
                          size: 40,
                        ),
                      // Show difficulty badge only if it's not empty
                      if (showDifficultyBadge) ...[
                        const SizedBox(width: AppConstants.spacingS),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.spacingS,
                            vertical: AppConstants.spacingXS,
                          ),
                          decoration: BoxDecoration(
                            color: statusColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusS,
                            ),
                          ),
                          child: Text(
                            difficulty!,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: statusColor),
                          ),
                        ),
                      ],
                      // Show trailing widgets if provided
                      if (trailingWidgets != null) ...[
                        const SizedBox(width: AppConstants.spacingS),
                        ...trailingWidgets!,
                      ],
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  // Title in separate line
                  Text(
                    title,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: isCompleted
                          ? AppConstants.successGreen
                          : Theme.of(context).colorScheme.onSurface,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppConstants.spacingS),
                  // Description
                  Flexible(
                    child: Text(
                      description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(
                          context,
                        ).colorScheme.onSurface.withValues(alpha: 0.8),
                      ),
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  // Progress bar
                  ChallengeProgressBar(
                    progress: progress,
                    leadingText: 'Progress',
                    trailingText: '${(progress * 100).round()}%',
                  ),
                  const SizedBox(height: AppConstants.spacingM),
                  // Badges section
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                        vertical: AppConstants.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: AppConstants.successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: AppConstants.spacingXS),
                          Text(
                            'Done',
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(color: AppConstants.successGreen),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
