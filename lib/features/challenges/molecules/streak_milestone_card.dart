import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/challenge_badge.dart';
import '../atoms/challenge_star.dart';

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
        ? OnboardingTheme.successGreen
        : isReached
        ? OnboardingTheme.warningOrange
        : OnboardingTheme.mediumGray;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: OnboardingTheme.white,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
          boxShadow: OnboardingTheme.cardShadow,
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
              // Header with streak badge and title
              Row(
                children: [
                  ChallengeBadge(
                    title: '$streakCount',
                    subtitle: 'Days',
                    icon: Icons.local_fire_department,
                    isCompleted: isAchieved,
                    iconColor: isAchieved ? OnboardingTheme.white : statusColor,
                    size: 50,
                  ),
                  const SizedBox(width: OnboardingTheme.spacingM),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: OnboardingTheme.headlineSmall.copyWith(
                            color: isAchieved
                                ? OnboardingTheme.successGreen
                                : OnboardingTheme.darkGray,
                          ),
                        ),
                        const SizedBox(height: OnboardingTheme.spacingXS),
                        // Streak progress indicator
                        Row(
                          children: [
                            Icon(
                              Icons.local_fire_department,
                              size: 16,
                              color: statusColor,
                            ),
                            const SizedBox(width: OnboardingTheme.spacingXS),
                            Text(
                              '$currentStreak/$streakCount days',
                              style: OnboardingTheme.bodySmall.copyWith(
                                color: statusColor,
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
                      color: OnboardingTheme.successGreen,
                      size: 24,
                    ),
                ],
              ),
              const SizedBox(height: OnboardingTheme.spacingM),
              // Description
              Text(description, style: OnboardingTheme.bodyMedium),
              const SizedBox(height: OnboardingTheme.spacingM),
              // Rewards section
              if (rewards != null && rewards!.isNotEmpty) ...[
                Divider(color: OnboardingTheme.lightGray, thickness: 1),
                const SizedBox(height: OnboardingTheme.spacingS),
                Text(
                  'Rewards',
                  style: OnboardingTheme.labelMedium.copyWith(
                    color: OnboardingTheme.darkGray,
                  ),
                ),
                const SizedBox(height: OnboardingTheme.spacingXS),
                Wrap(
                  spacing: OnboardingTheme.spacingS,
                  runSpacing: OnboardingTheme.spacingS,
                  children: rewards!.map((reward) {
                    return Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.spacingS,
                        vertical: OnboardingTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingTheme.lightGray,
                        borderRadius: BorderRadius.circular(
                          OnboardingTheme.radiusS,
                        ),
                      ),
                      child: Text(reward, style: OnboardingTheme.bodySmall),
                    );
                  }).toList(),
                ),
              ],
              const SizedBox(height: OnboardingTheme.spacingM),
              // Action button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  if (isAchieved)
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
                      child: Text(
                        'Achieved',
                        style: OnboardingTheme.labelMedium.copyWith(
                          color: OnboardingTheme.successGreen,
                        ),
                      ),
                    )
                  else if (isReached)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.spacingM,
                        vertical: OnboardingTheme.spacingS,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingTheme.warningOrange.withValues(
                          alpha: 0.1,
                        ),
                        borderRadius: BorderRadius.circular(
                          OnboardingTheme.radiusM,
                        ),
                      ),
                      child: Text(
                        'Claim Reward',
                        style: OnboardingTheme.labelMedium.copyWith(
                          color: OnboardingTheme.warningOrange,
                        ),
                      ),
                    )
                  else
                    Text(
                      '${streakCount - currentStreak} days left',
                      style: OnboardingTheme.bodySmall.copyWith(
                        color: OnboardingTheme.mediumGray,
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
