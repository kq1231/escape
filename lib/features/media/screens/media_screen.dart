import 'package:escape/models/post_model.dart';
import 'package:escape/providers/posts_provider.dart';
import 'package:escape/widgets/shimmer.dart';
import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';
import '../atoms/media_tag.dart';
import '../molecules/article_card.dart';
import '../molecules/video_card.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'post_page.dart';

enum SortOption { latest, popular, oldest }

class MediaScreen extends ConsumerStatefulWidget {
  const MediaScreen({super.key});

  @override
  ConsumerState<MediaScreen> createState() => _MediaScreenState();
}

class _MediaScreenState extends ConsumerState<MediaScreen> {
  String _selectedCategory = 'All';
  PostType? _currentFilter;
  SortOption _currentSort = SortOption.latest;
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
      ref.read(postsProviderProvider.notifier).loadMorePosts();
    }
  }

  void _changeSort(SortOption sort) {
    setState(() {
      _currentSort = sort;
    });

    // Fetch posts based on sort option
    switch (sort) {
      case SortOption.latest:
        ref.read(postsProviderProvider.notifier).refreshPosts();
        break;
      case SortOption.popular:
        ref.read(postsProviderProvider.notifier).loadPopularPosts();
        break;
      case SortOption.oldest:
        ref.read(postsProviderProvider.notifier).loadOldestPosts();
        break;
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

    // Always call filterPosts, even for "All"
    ref.read(postsProviderProvider.notifier).filterPosts(_currentFilter);
  }

  @override
  Widget build(BuildContext context) {
    final postsAsyncValue = ref.watch(postsProviderProvider);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDarkMode
          ? AppConstants.darkBackground
          : AppConstants.lightBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            color: AppConstants.primaryGreen,
            backgroundColor: isDarkMode ? AppConstants.darkCard : Colors.white,
            onRefresh: () async {
              await ref.read(postsProviderProvider.notifier).refreshPosts();
            },
            child: CustomScrollView(
              controller: _scrollController,
              slivers: [
                // Sorting chips
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingM,
                      ),
                      children: [
                        _buildSortChip('Latest', SortOption.latest),
                        SizedBox(width: AppConstants.spacingS),
                        _buildSortChip('Popular', SortOption.popular),
                        SizedBox(width: AppConstants.spacingS),
                        _buildSortChip('Oldest', SortOption.oldest),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingM),
                ),

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
                              : isDarkMode
                              ? AppConstants.darkCard
                              : AppConstants.lightGray,
                          textColor: _selectedCategory == 'All'
                              ? AppConstants.white
                              : isDarkMode
                              ? AppConstants.lightGray
                              : AppConstants.darkGray,
                          onTap: () => _filterContent('All'),
                        ),
                        SizedBox(width: AppConstants.spacingS),
                        MediaTag(
                          label: 'Articles',
                          backgroundColor: _selectedCategory == 'Articles'
                              ? AppConstants.primaryGreen
                              : isDarkMode
                              ? AppConstants.darkCard
                              : AppConstants.lightGray,
                          textColor: _selectedCategory == 'Articles'
                              ? AppConstants.white
                              : isDarkMode
                              ? AppConstants.lightGray
                              : AppConstants.darkGray,
                          onTap: () => _filterContent('Articles'),
                        ),
                        SizedBox(width: AppConstants.spacingS),
                        MediaTag(
                          label: 'Videos',
                          backgroundColor: _selectedCategory == 'Videos'
                              ? AppConstants.primaryGreen
                              : isDarkMode
                              ? AppConstants.darkCard
                              : AppConstants.lightGray,
                          textColor: _selectedCategory == 'Videos'
                              ? AppConstants.white
                              : isDarkMode
                              ? AppConstants.lightGray
                              : AppConstants.darkGray,
                          onTap: () => _filterContent('Videos'),
                        ),
                        // Other tags...
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(height: AppConstants.spacingM),
                ),

                // Media feed
                postsAsyncValue.when(
                  loading: () => SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) => _buildShimmerCard(isDarkMode),
                      childCount: 5,
                    ),
                  ),
                  error: (error, stack) => SliverToBoxAdapter(
                    child: Center(
                      child: Text(
                        'Error loading posts: $error',
                        style: TextStyle(
                          color: isDarkMode
                              ? AppConstants.lightGray
                              : AppConstants.darkGray,
                        ),
                      ),
                    ),
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
                          isDarkMode: isDarkMode,
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
                          isDarkMode: isDarkMode,
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
        ),
      ),
    );
  }

  // Helper method to build sort chips
  Widget _buildSortChip(String label, SortOption sortOption) {
    final isSelected = _currentSort == sortOption;
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: () => _changeSort(sortOption),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? AppConstants.primaryGreen
              : isDarkMode
              ? AppConstants.darkCard
              : AppConstants.lightGray,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? AppConstants.primaryGreen
                : isDarkMode
                ? AppConstants.darkBorder
                : AppConstants.lightBorder,
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isSelected
                  ? AppConstants.white
                  : isDarkMode
                  ? AppConstants.lightGray
                  : AppConstants.darkGray,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }

  // Updated shimmer card builder with dark mode support
  Widget _buildShimmerCard(bool isDarkMode) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.spacingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerContainer(
            height: 200,
            width: double.infinity,
            borderRadius: 8,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 20,
            width: double.infinity,
            borderRadius: 4,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          _buildShimmerContainer(
            height: 15,
            width: double.infinity,
            borderRadius: 4,
            isDarkMode: isDarkMode,
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildShimmerContainer(
                height: 15,
                width: 60,
                borderRadius: 12,
                isDarkMode: isDarkMode,
              ),
              const SizedBox(width: 8),
              _buildShimmerContainer(
                height: 15,
                width: 60,
                borderRadius: 12,
                isDarkMode: isDarkMode,
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Updated shimmer container with dark mode support
  Widget _buildShimmerContainer({
    required double height,
    required double width,
    double borderRadius = 0,
    required bool isDarkMode,
  }) {
    return Shimmer(
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
}
