import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../molecules/article_card.dart';
import '../molecules/video_card.dart';

class MediaFeed extends StatelessWidget {
  final List<Widget> items;
  final String? title;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const MediaFeed({
    super.key,
    required this.items,
    this.title,
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingTheme.spacingM,
            ),
            child: Text(
              title!,
              style: OnboardingTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: OnboardingTheme.spacingM),
        ],
        // Content
        if (isLoading) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(OnboardingTheme.spacingL),
              child: CircularProgressIndicator(),
            ),
          ),
        ] else ...[
          // Refresh indicator
          RefreshIndicator(
            onRefresh: () async {
              if (onRefresh != null) {
                onRefresh!();
              }
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: OnboardingTheme.spacingM,
                    right: OnboardingTheme.spacingM,
                    bottom: OnboardingTheme.spacingM,
                  ),
                  child: items[index],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
