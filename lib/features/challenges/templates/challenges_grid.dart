import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
                  child: Text(
                    title!,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                ),
              if (showViewAllButton)
                TextButton(
                  onPressed: onViewAllPressed,
                  child: Text(
                    'View All',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                ),
            ],
          ),
          if (subtitle != null) ...[
            const SizedBox(height: AppTheme.spacingXS),
            Text(
              subtitle!,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
            ),
          ],
          const SizedBox(height: AppTheme.spacingM),
        ],
        // Grid of challenge items
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = (constraints.maxWidth - AppTheme.spacingM) / 2;
            final cardHeight = cardWidth * 1.2; // Adjust aspect ratio as needed

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppTheme.spacingM,
                mainAxisSpacing: AppTheme.spacingM,
                childAspectRatio: cardWidth / cardHeight,
              ),
              itemCount: challengeItems.length,
              itemBuilder: (context, index) {
                return challengeItems[index];
              },
            );
          },
        ),
      ],
    );
  }
}
