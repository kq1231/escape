import 'package:escape/models/post_model.dart';
import 'package:escape/providers/posts_provider.dart';
import 'package:escape/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/media_tag.dart';
import '../molecules/article_card.dart';
import '../molecules/video_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_page.dart';

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  String _selectedCategory = 'All';
  PostType? _currentFilter;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      // Load more posts when reaching the bottom
      ref.read(postsProviderProvider().notifier).loadMorePosts();
    }
  }

  void _filterContent(String category) {
    setState(() {
      _selectedCategory = category;
      switch (category) {
        case 'Articles':
          _currentFilter = PostType.article;
          break;
        case 'Videos':
          _currentFilter = PostType.video;
          break;
        default:
          _currentFilter = null;
      }
    });
    // Use the provider to filter posts
    ref.read(postsProviderProvider().notifier).filterPosts(_currentFilter);
  }

  @override
  Widget build(BuildContext context) {
    final postsAsyncValue = ref.watch(postsProviderProvider());

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(postsProviderProvider().notifier).refreshPosts();
        },
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Category tags
            SliverToBoxAdapter(
              child: SizedBox(
                height: 50,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.spacingM,
                  ),
                  children: [
                    MediaTag(
                      label: 'All',
                      backgroundColor: _selectedCategory == 'All'
                          ? AppConstants.primaryGreen
                          : AppConstants.lightGray,
                      textColor: _selectedCategory == 'All'
                          ? AppConstants.white
                          : AppConstants.darkGray,
                      onTap: () => _filterContent('All'),
                    ),
                    SizedBox(width: AppConstants.spacingS),
                    MediaTag(
                      label: 'Articles',
                      backgroundColor: _selectedCategory == 'Articles'
                          ? AppConstants.primaryGreen
                          : AppConstants.lightGray,
                      textColor: _selectedCategory == 'Articles'
                          ? AppConstants.white
                          : AppConstants.darkGray,
                      onTap: () => _filterContent('Articles'),
                    ),
                    SizedBox(width: AppConstants.spacingS),
                    MediaTag(
                      label: 'Videos',
                      backgroundColor: _selectedCategory == 'Videos'
                          ? AppConstants.primaryGreen
                          : AppConstants.lightGray,
                      textColor: _selectedCategory == 'Videos'
                          ? AppConstants.white
                          : AppConstants.darkGray,
                      onTap: () => _filterContent('Videos'),
                    ),
                    // Other tags...
                  ],
                ),
              ),
            ),
            SliverToBoxAdapter(child: SizedBox(height: AppConstants.spacingM)),
            // Media feed
            postsAsyncValue.when(
              loading: () => SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => _buildShimmerCard(),
                  childCount: 5,
                ),
              ),
              error: (error, stack) => SliverToBoxAdapter(
                child: Center(child: Text('Error loading posts: $error')),
              ),
              data: (posts) => SliverList(
                delegate: SliverChildBuilderDelegate((context, index) {
                  final post = posts[index];
                  if (post.postType == PostType.article) {
                    return ArticleCard(
                      title: post.title,
                      imageUrl: post.featuredImageUrl ?? '',
                      excerpt: post.excerpt ?? '',
                      tags: post.tags,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostPage(postId: post.id),
                          ),
                        );
                      },
                    );
                  } else if (post.postType == PostType.video) {
                    return VideoCard(
                      title: post.title,
                      thumbnailUrl: post.featuredImageUrl ?? '',
                      duration: post.duration.toString(),
                      views: post.viewsCount,
                      author: post.author?.name,
                      tags: post.tags,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => PostPage(postId: post.id),
                          ),
                        );
                      },
                    );
                  }
                  return const SizedBox.shrink();
                }, childCount: posts.length),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerContainer(
            height: 200,
            width: double.infinity,
            borderRadius: 8,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 20,
            width: double.infinity,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 15,
            width: double.infinity,
            borderRadius: 4,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildShimmerContainer(height: 15, width: 60, borderRadius: 12),
              const SizedBox(width: 8),
              _buildShimmerContainer(height: 15, width: 60, borderRadius: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerContainer({
    required double height,
    required double width,
    double borderRadius = 0,
  }) {
    return Shimmer(
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}
