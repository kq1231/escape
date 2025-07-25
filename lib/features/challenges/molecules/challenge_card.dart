import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
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
        ? OnboardingTheme.successGreen
        : progress > 0
        ? OnboardingTheme.warningOrange
        : OnboardingTheme.mediumGray;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: OnboardingTheme.white,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
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
          padding: const EdgeInsets.all(OnboardingTheme.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row with leading widget, title, and trailing widgets
              Row(
                children: [
                  if (leadingWidget != null) ...[
                    leadingWidget!,
                    const SizedBox(width: OnboardingTheme.spacingS),
                  ] else
                    ChallengeBadge(
                      title: title.substring(0, 1),
                      isCompleted: isCompleted,
                      size: 40,
                    ),
                  const SizedBox(width: OnboardingTheme.spacingS),
                  Expanded(
                    child: Text(
                      title,
                      style: OnboardingTheme.headlineSmall.copyWith(
                        color: isCompleted
                            ? OnboardingTheme.successGreen
                            : OnboardingTheme.darkGray,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trailingWidgets != null) ...[
                    const SizedBox(width: OnboardingTheme.spacingS),
                    ...trailingWidgets!,
                  ] else if (difficulty != null) ...[
                    const SizedBox(width: OnboardingTheme.spacingS),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.spacingS,
                        vertical: OnboardingTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(
                          OnboardingTheme.radiusS,
                        ),
                      ),
                      child: Text(
                        difficulty!,
                        style: OnboardingTheme.labelMedium.copyWith(
                          color: statusColor,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: OnboardingTheme.spacingS),
              // Description
              Text(
                description,
                style: OnboardingTheme.bodyMedium,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: OnboardingTheme.spacingM),
              // Progress bar
              ChallengeProgressBar(
                progress: progress,
                leadingText: 'Progress',
                trailingText: '${(progress * 100).round()}%',
              ),
              const SizedBox(height: OnboardingTheme.spacingM),
              // Rating and action row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ChallengeStar(rating: rating, maxRating: maxRating, size: 18),
                  if (isCompleted)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.spacingM,
                        vertical: OnboardingTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingTheme.successGreen.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          OnboardingTheme.radiusM,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle,
                            color: OnboardingTheme.successGreen,
                            size: 16,
                          ),
                          const SizedBox(width: OnboardingTheme.spacingXS),
                          Text(
                            'Completed',
                            style: OnboardingTheme.labelMedium.copyWith(
                              color: OnboardingTheme.successGreen,
                              fontSize: 12,
                            ),
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
