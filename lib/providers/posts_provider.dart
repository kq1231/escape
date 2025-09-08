import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/posts_repository.dart';
import '../models/post_model.dart';
import '../../features/media/screens/media_screen.dart';
part 'posts_provider.g.dart';

@Riverpod()
class PostsProvider extends _$PostsProvider {
  PostType? _currentFilter;
  final SortOption _currentSort = SortOption.latest;

  @override
  Future<List<PostPreview>> build() async {
    // Start with no filter
    return await ref
        .read(postsRepositoryProvider.notifier)
        .getLatestPosts(filter: null);
  }

  // Load more posts
  Future<void> loadMorePosts() async {
    final currentPosts = await future;
    final currentOffset = currentPosts.length;

    List<PostPreview> newPosts;

    switch (_currentSort) {
      case SortOption.latest:
        newPosts = await ref
            .read(postsRepositoryProvider.notifier)
            .getLatestPosts(offset: currentOffset, filter: _currentFilter);
        break;
      case SortOption.popular:
        newPosts = await ref
            .read(postsRepositoryProvider.notifier)
            .getPopularPosts(offset: currentOffset, filter: _currentFilter);
        break;
      case SortOption.oldest:
        newPosts = await ref
            .read(postsRepositoryProvider.notifier)
            .getOldestPosts(offset: currentOffset, filter: _currentFilter);
        break;
    }

    final hasMore = newPosts.length >= 10;
    if (!hasMore) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return [...currentPosts, ...newPosts];
    });
  }

  // Refresh posts
  Future<void> refreshPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      switch (_currentSort) {
        case SortOption.latest:
          return await ref
              .read(postsRepositoryProvider.notifier)
              .getLatestPosts(filter: _currentFilter);
        case SortOption.popular:
          return await ref
              .read(postsRepositoryProvider.notifier)
              .getPopularPosts(filter: _currentFilter);
        case SortOption.oldest:
          return await ref
              .read(postsRepositoryProvider.notifier)
              .getOldestPosts(filter: _currentFilter);
      }
    });
  }

  // Filter posts by type
  Future<void> filterPosts(PostType? newFilter) async {
    // Always update, even if same filter (for "All" -> "All" case)
    _currentFilter = newFilter;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getLatestPosts(filter: newFilter);
    });
  }

  // Search posts
  Future<void> searchPosts(String query) async {
    if (query.trim().isEmpty) {
      refreshPosts();
      return;
    }

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getLatestPosts(searchQuery: query, filter: _currentFilter);
    });
  }

  // Get popular posts
  Future<void> loadPopularPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getPopularPosts(filter: _currentFilter);
    });
  }

  // Method to load oldest posts
  Future<void> loadOldestPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getOldestPosts(filter: _currentFilter);
    });
  }
}
