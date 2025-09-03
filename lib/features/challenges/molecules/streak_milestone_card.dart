import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/challenge_badge.dart';

class StreakMilestoneCard extends StatelessWidget {
  final int streakCount;
  final String title;
  final String description;
  final bool isAchieved;
  final int currentStreak;
  final VoidCallback? onTap;
  final List<String>? rewards;

  const StreakMilestoneCard({
    super.key,
    required this.streakCount,
    required this.title,
    required this.description,
    this.isAchieved = false,
    this.currentStreak = 0,
    this.onTap,
    this.rewards,
  });

  @override
  Widget build(BuildContext context) {
    final isReached = currentStreak >= streakCount;
    final statusColor = isAchieved
        ? AppConstants.successGreen
        : isReached
        ? AppConstants.warningOrange
        : AppConstants.mediumGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppConstants.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: AppConstants.cardShadow,
          border: Border.all(
            color: statusColor.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with streak badge and title
              Row(
                children: [
                  ChallengeBadge(
                    title: '$streakCount',
                    subtitle: 'Days',
                    icon: Icons.local_fire_department,
                    isCompleted: isAchieved,
                    iconColor: isAchieved ? AppConstants.white : statusColor,
                    size: 50,
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.displaySmall
                              ?.copyWith(
                                color: isAchieved
                                    ? AppConstants.successGreen
                                    : AppConstants.darkGray,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacingXS),
                        // Streak progress indicator
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: AppConstants.spacingXS),
                            Text(
                              '$currentStreak/$streakCount days',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (isAchieved)
                    Icon(
                      Icons.check_circle,
                      color: AppConstants.successGreen,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingM),
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
              const SizedBox(height: AppConstants.spacingM),
              // Rewards section
              if (rewards != null && rewards!.isNotEmpty) ...[
                Divider(color: AppConstants.lightGray, thickness: 1),
                const SizedBox(height: AppConstants.spacingS),
                Text(
                  'Rewards',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: AppConstants.darkGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXS),
                Wrap(
                  spacing: AppConstants.spacingS,
                  runSpacing: AppConstants.spacingS,
                  children: rewards!.map((reward) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.lightGray,
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: Text(
                        reward,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: AppConstants.spacingM),
              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAchieved)
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
                      child: Text(
                        'Achieved',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppConstants.successGreen,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  else if (isReached)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                        vertical: AppConstants.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.warningOrange.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusM,
                        ),
                      ),
                      child: Text(
                        'Claim Reward',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: AppConstants.warningOrange,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    )
                  else
                    Text(
                      '${streakCount - currentStreak} days left',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                        fontWeight: FontWeight.w500,
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
