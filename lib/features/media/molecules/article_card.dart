import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';
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
  final bool isDarkMode;

  const ArticleCard({
    super.key,
    required this.title,
    this.imageUrl,
    this.tags = const [],
    this.excerpt,
    this.onTap,
    this.onTagTap,
    this.isDarkMode = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: isDarkMode ? AppConstants.darkCard : AppConstants.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: AppConstants.cardShadow,
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
            SizedBox(height: AppConstants.spacingM),
            // Title
            MediaTitle(
              title: title,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            if (excerpt != null) ...[
              SizedBox(height: AppConstants.spacingXS),
              Text(
                excerpt!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode
                      ? AppConstants.lightGray
                      : AppConstants.mediumGray,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
            SizedBox(height: AppConstants.spacingS),
            // Tags
            if (tags.isNotEmpty) ...[
              Wrap(
                spacing: AppConstants.spacingS,
                runSpacing: AppConstants.spacingS,
                children: tags.map((tag) {
                  return MediaTag(
                    label: tag,
                    backgroundColor: isDarkMode
                        ? AppConstants.darkCard
                        : AppConstants.lightGray,
                    textColor: isDarkMode
                        ? AppConstants.lightGray
                        : AppConstants.darkGray,
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
