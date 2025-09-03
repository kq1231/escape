import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
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
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppConstants.white,
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
                  color: AppConstants.mediumGray,
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
                    backgroundColor: AppConstants.lightGray,
                    textColor: AppConstants.darkGray,
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
