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
        ? AppTheme.successGreen
        : isReached
        ? AppTheme.warningOrange
        : AppTheme.mediumGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: AppTheme.cardShadow,
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
              // Header with streak badge and title
              Row(
                children: [
                  ChallengeBadge(
                    title: '$streakCount',
                    subtitle: 'Days',
                    icon: Icons.local_fire_department,
                    isCompleted: isAchieved,
                    iconColor: isAchieved ? AppTheme.white : statusColor,
                    size: 50,
                  ),
                  const SizedBox(width: AppTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: AppTheme.headlineSmall.copyWith(
                            color: isAchieved
                                ? AppTheme.successGreen
                                : AppTheme.darkGray,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: AppTheme.spacingXS),
                        // Streak progress indicator
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: AppTheme.spacingXS),
                            Text(
                              '$currentStreak/$streakCount days',
                              style: AppTheme.bodyMedium.copyWith(
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
                      color: AppTheme.successGreen,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Description
              Flexible(
                child: Text(
                  description,
                  style: AppTheme.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
              // Rewards section
              if (rewards != null && rewards!.isNotEmpty) ...[
                Divider(color: AppTheme.lightGray, thickness: 1),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Rewards',
                  style: AppTheme.labelMedium.copyWith(
                    color: AppTheme.darkGray,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: AppTheme.spacingXS),
                Wrap(
                  spacing: AppTheme.spacingS,
                  runSpacing: AppTheme.spacingS,
                  children: rewards!.map((reward) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.lightGray,
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        reward,
                        style: AppTheme.bodyMedium.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: AppTheme.spacingM),
              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAchieved)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.successGreen.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Text(
                        'Achieved',
                        style: AppTheme.labelMedium.copyWith(
                          color: AppTheme.successGreen,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else if (isReached)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingM,
                        vertical: AppTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.warningOrange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(AppTheme.radiusM),
                      ),
                      child: Text(
                        'Claim Reward',
                        style: AppTheme.labelMedium.copyWith(
                          color: AppTheme.warningOrange,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  else
                    Text(
                      '${streakCount - currentStreak} days left',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
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
