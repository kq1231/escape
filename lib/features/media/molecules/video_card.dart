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
        padding: const EdgeInsets.all(AppTheme.spacingM),
        decoration: BoxDecoration(
          color: AppTheme.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusL),
          boxShadow: AppTheme.cardShadow,
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
                        color: AppTheme.primaryGreen.withValues(alpha: 0.8),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.play_arrow,
                        color: AppTheme.white,
                        size: 30,
                      ),
                    ),
                  ),
                ),
                // Duration badge
                if (duration != null)
                  Positioned(
                    right: AppTheme.spacingS,
                    bottom: AppTheme.spacingS,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacingS,
                        vertical: AppTheme.spacingXS,
                      ),
                      decoration: BoxDecoration(
                        color: AppTheme.black.withValues(alpha: 0.7),
                        borderRadius: BorderRadius.circular(AppTheme.radiusS),
                      ),
                      child: Text(
                        duration!,
                        style: AppTheme.labelMedium.copyWith(
                          color: AppTheme.white,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: AppTheme.spacingM),
            // Title
            MediaTitle(
              title: title,
              style: AppTheme.headlineSmall.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            // Metadata
            if (author != null || views != null) ...[
              SizedBox(height: AppTheme.spacingXS),
              Row(
                children: [
                  if (author != null) ...[
                    Text(
                      author!,
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                  if (author != null && views != null) ...[
                    Text(
                      ' • ',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                  if (views != null) ...[
                    Text(
                      '${views!} views',
                      style: AppTheme.bodyMedium.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                  ],
                ],
              ),
            ],
            SizedBox(height: AppTheme.spacingS),
            // Tags
            if (tags.isNotEmpty) ...[
              Wrap(
                spacing: AppTheme.spacingS,
                runSpacing: AppTheme.spacingS,
                children: tags.map((tag) {
                  return MediaTag(
                    label: tag,
                    backgroundColor: AppTheme.lightGray,
                    textColor: AppTheme.darkGray,
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
