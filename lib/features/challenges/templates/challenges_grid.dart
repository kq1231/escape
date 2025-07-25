import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../molecules/challenge_card.dart';
import '../molecules/streak_milestone_card.dart';

class ChallengesGrid extends StatelessWidget {
  final List<Widget> challengeItems;
  final String? title;
  final String? subtitle;
  final VoidCallback? onViewAllPressed;
  final bool showViewAllButton;
  final CrossAxisAlignment? titleAlignment;

  const ChallengesGrid({
    super.key,
    required this.challengeItems,
    this.title,
    this.subtitle,
    this.onViewAllPressed,
    this.showViewAllButton = false,
    this.titleAlignment = CrossAxisAlignment.start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: titleAlignment ?? CrossAxisAlignment.start,
      children: [
        // Header section with title and view all button
        if (title != null || showViewAllButton) ...[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (title != null)
                Expanded(
                  child: Text(title!, style: OnboardingTheme.headlineMedium),
                ),
              if (showViewAllButton)
                TextButton(
                  onPressed: onViewAllPressed,
                  child: Text(
                    'View All',
                    style: OnboardingTheme.labelMedium.copyWith(
                      color: OnboardingTheme.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: OnboardingTheme.spacingXS),
            Text(
              subtitle!,
              style: OnboardingTheme.bodyMedium.copyWith(
                color: OnboardingTheme.mediumGray,
              ),
            ),
          ],
          const SizedBox(height: OnboardingTheme.spacingM),
        ],
        // Grid of challenge items
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: OnboardingTheme.spacingM,
            mainAxisSpacing: OnboardingTheme.spacingM,
            childAspectRatio: 0.85,
          ),
          itemCount: challengeItems.length,
          itemBuilder: (context, index) {
            return challengeItems[index];
          },
        ),
      ],
    );
  }
}
