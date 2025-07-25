import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/article_thumbnail.dart';
import '../atoms/media_title.dart';
import '../atoms/media_tag.dart';

class ArticleCard extends StatelessWidget {
  final String title;
  final String? imageUrl;
  final List<String> tags;
  final String? excerpt;
  final VoidCallback? onTap;
  final VoidCallback? onTagTap;

  const ArticleCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.tags = const [],
    this.excerpt,
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
            // Thumbnail
            ArticleThumbnail(
              imageUrl: imageUrl,
              height: 180,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            SizedBox(height: OnboardingTheme.spacingM),
            // Title
            MediaTitle(
              title: title,
              style: OnboardingTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            if (excerpt != null) ...[
              SizedBox(height: OnboardingTheme.spacingXS),
              Text(
                excerpt!,
                style: OnboardingTheme.bodyMedium.copyWith(
                  color: OnboardingTheme.mediumGray,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
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
