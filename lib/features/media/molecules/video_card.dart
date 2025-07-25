import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/article_thumbnail.dart';
import '../atoms/media_title.dart';
import '../atoms/media_tag.dart';

class VideoCard extends StatelessWidget {
  final String title;
  final String? thumbnailUrl;
  final List<String> tags;
  final String? duration;
  final int? views;
  final String? author;
  final VoidCallback? onTap;
  final VoidCallback? onTagTap;

  const VideoCard({
    super.key,
    required this.title,
    this.thumbnailUrl,
    this.tags = const [],
    this.duration,
    this.views,
    this.author,
    this.onTap,
    this.onTagTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(OnboardingTheme.spacingM),
        decoration: BoxDecoration(
          color: OnboardingTheme.white,
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
          boxShadow: OnboardingTheme.cardShadow,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video thumbnail with play button overlay
            Stack(
              children: [
                ArticleThumbnail(
                  imageUrl: thumbnailUrl,
                  height: 180,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                // Play button overlay
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: Center(
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        color: OnboardingTheme.primaryGreen.withValues(
                          alpha: 0.8,
                        ),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: OnboardingTheme.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Duration badge
                if (duration != null)
                  Positioned(
                    right: OnboardingTheme.spacingS,
                    bottom: OnboardingTheme.spacingS,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: OnboardingTheme.spacingS,
                        vertical: OnboardingTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: OnboardingTheme.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(
                          OnboardingTheme.radiusS,
                        ),
                      ),
                      child: Text(
                        duration!,
                        style: OnboardingTheme.labelMedium.copyWith(
                          color: OnboardingTheme.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: OnboardingTheme.spacingM),
            // Title
            MediaTitle(
              title: title,
              style: OnboardingTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Metadata
            if (author != null || views != null) ...[
              SizedBox(height: OnboardingTheme.spacingXS),
              Row(
                children: [
                  if (author != null) ...[
                    Text(
                      author!,
                      style: OnboardingTheme.bodyMedium.copyWith(
                        color: OnboardingTheme.mediumGray,
                      ),
                    ),
                  ],
                  if (author != null && views != null) ...[
                    Text(
                      ' • ',
                      style: OnboardingTheme.bodyMedium.copyWith(
                        color: OnboardingTheme.mediumGray,
                      ),
                    ),
                  ],
                  if (views != null) ...[
                    Text(
                      '${views!} views',
                      style: OnboardingTheme.bodyMedium.copyWith(
                        color: OnboardingTheme.mediumGray,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            SizedBox(height: OnboardingTheme.spacingS),
            // Tags
            if (tags.isNotEmpty) ...[
              Wrap(
                spacing: OnboardingTheme.spacingS,
                runSpacing: OnboardingTheme.spacingS,
                children: tags.map((tag) {
                  return MediaTag(
                    label: tag,
                    backgroundColor: OnboardingTheme.lightGray,
                    textColor: OnboardingTheme.darkGray,
                    onTap: onTagTap,
                  );
                }).toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
