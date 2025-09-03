import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
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
        padding: const EdgeInsets.all(AppConstants.spacingM),
        decoration: BoxDecoration(
          color: AppConstants.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          boxShadow: AppConstants.cardShadow,
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
                        color: AppConstants.primaryGreen.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppConstants.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Duration badge
                if (duration != null)
                  Positioned(
                    right: AppConstants.spacingS,
                    bottom: AppConstants.spacingS,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingS,
                        vertical: AppConstants.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppConstants.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusS,
                        ),
                      ),
                      child: Text(
                        duration!,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(color: AppConstants.white),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppConstants.spacingM),
            // Title
            MediaTitle(
              title: title,
              style: Theme.of(
                context,
              ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            // Metadata
            if (author != null || views != null) ...[
              SizedBox(height: AppConstants.spacingXS),
              Row(
                children: [
                  if (author != null) ...[
                    Text(
                      author!,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  ],
                  if (author != null && views != null) ...[
                    Text(
                      ' • ',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  ],
                  if (views != null) ...[
                    Text(
                      '${views!} views',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppConstants.mediumGray,
                      ),
                    ),
                  ],
                ],
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
