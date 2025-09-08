import 'package:escape/models/post_model.dart';
import 'package:escape/providers/post_provider.dart';
import 'package:escape/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class PostPage extends ConsumerStatefulWidget {
  final String postId;
  const PostPage({super.key, required this.postId});

  @override
  ConsumerState<PostPage> createState() => _PostPageState();
}

class _PostPageState extends ConsumerState<PostPage> {
  YoutubePlayerController? _youtubeController;

  @override
  void dispose() {
    _youtubeController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final postAsyncValue = ref.watch(postProviderProvider(widget.postId));
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Post Details')),
      body: postAsyncValue.when(
        loading: () => _buildShimmerLoading(isDarkMode),
        error: (error, stack) =>
            Center(child: Text('Error loading post: $error')),
        data: (post) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post title
              Text(
                post.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),

              // Post image or video thumbnail
              if (post.postType == PostType.video && post.videoUrl != null)
                _buildVideoPlayer(post.videoUrl!, isDarkMode)
              else if (post.featuredImageUrl != null)
                CachedNetworkImage(
                  imageUrl: post.featuredImageUrl!,
                  placeholder: (context, url) => _buildShimmerContainer(
                    height: 200,
                    width: double.infinity,
                    isDarkMode: isDarkMode,
                  ),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: 200,
                ),

              const SizedBox(height: AppConstants.spacingM),

              // Post metadata
              Row(
                children: [
                  if (post.author != null) ...[
                    const Icon(Icons.person, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      post.author!.name,
                      style: TextStyle(
                        color: isDarkMode
                            ? AppConstants.lightGray
                            : AppConstants.darkGray,
                      ),
                    ),
                    const SizedBox(width: AppConstants.spacingM),
                  ],
                  const Icon(Icons.calendar_today, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    _formatDate(post.createdAt),
                    style: TextStyle(
                      color: isDarkMode
                          ? AppConstants.lightGray
                          : AppConstants.darkGray,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  const Icon(Icons.visibility, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    '${post.viewsCount} views',
                    style: TextStyle(
                      color: isDarkMode
                          ? AppConstants.lightGray
                          : AppConstants.darkGray,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingM),

              // Post tags
              if (post.tags.isNotEmpty)
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: post.tags
                      .map(
                        (tag) => Chip(
                          label: Text(tag),
                          backgroundColor: AppConstants.primaryGreen.withValues(
                            alpha: 0.2,
                          ),
                        ),
                      )
                      .toList(),
                ),

              const SizedBox(height: AppConstants.spacingM),

              // Post content
              if (post.content != null && post.content!.isNotEmpty)
                MarkdownBody(
                  data: post.content!,
                  selectable: true,
                  styleSheet: MarkdownStyleSheet.fromTheme(Theme.of(context))
                      .copyWith(
                        p: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDarkMode
                              ? AppConstants.lightGray
                              : AppConstants.darkGray,
                        ),
                        h1: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: isDarkMode
                                  ? AppConstants.white
                                  : AppConstants.darkGray,
                            ),
                        h2: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: isDarkMode
                              ? AppConstants.white
                              : AppConstants.darkGray,
                        ),
                        h3: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: isDarkMode
                              ? AppConstants.white
                              : AppConstants.darkGray,
                        ),
                        code: const TextStyle(fontFamily: 'monospace'),
                        codeblockDecoration: BoxDecoration(
                          color: isDarkMode
                              ? Colors.grey[800]
                              : Colors.grey[200],
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                )
              else
                Text(
                  'No content available',
                  style: TextStyle(
                    color: isDarkMode
                        ? AppConstants.lightGray
                        : AppConstants.darkGray,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVideoPlayer(String videoUrl, bool isDarkMode) {
    // Check if it's a YouTube URL
    if (videoUrl.contains('youtube.com') || videoUrl.contains('youtu.be')) {
      final videoId = YoutubePlayer.convertUrlToId(videoUrl);
      if (videoId != null) {
        return YoutubePlayer(
          controller: _youtubeController ??= YoutubePlayerController(
            initialVideoId: videoId,
            flags: const YoutubePlayerFlags(autoPlay: false, mute: false),
          ),
          showVideoProgressIndicator: true,
        );
      }
    }
    // Fallback to thumbnail
    return CachedNetworkImage(
      imageUrl: videoUrl,
      placeholder: (context, url) => _buildShimmerContainer(
        height: 200,
        width: double.infinity,
        isDarkMode: isDarkMode,
      ),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      fit: BoxFit.cover,
      width: double.infinity,
      height: 200,
    );
  }

  Widget _buildShimmerLoading(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerContainer(
            height: 30,
            width: double.infinity,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          _buildShimmerContainer(
            height: 200,
            width: double.infinity,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              _buildShimmerContainer(
                height: 16,
                width: 100,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: 16),
              _buildShimmerContainer(
                height: 16,
                width: 100,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildShimmerContainer(
            height: 16,
            width: double.infinity,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 16,
            width: double.infinity,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 16,
            width: 200,
            isDarkMode: isDarkMode,
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
    double borderRadius = 0,
    required bool isDarkMode,
  }) {
    return Shimmer(
      baseColor: isDarkMode ? Colors.grey[400]! : Colors.grey[300]!,
      highlightColor: isDarkMode ? Colors.grey[700]! : Colors.grey[200]!,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: isDarkMode ? Colors.grey[800] : Colors.grey[300],
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
