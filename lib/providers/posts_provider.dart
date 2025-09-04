import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/posts_repository.dart';
import '../models/post_model.dart';
part 'posts_provider.g.dart';

@Riverpod()
class PostsProvider extends _$PostsProvider {
  @override
  Future<List<PostPreview>> build({PostType? filter}) async {
    // Initialize the posts repository
    await ref.read(postsRepositoryProvider.future);
    return await ref
        .read(postsRepositoryProvider.notifier)
        .getLatestPosts(filter: filter);
  }

  // Load more posts
  Future<void> loadMorePosts() async {
    final currentPosts = await future;
    final currentOffset = currentPosts.length;

    // Get new posts
    final newPosts = await ref
        .read(postsRepositoryProvider.notifier)
        .getLatestPosts(offset: currentOffset, filter: filter);

    // Check if we have more posts based on the number of results
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
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getLatestPosts(filter: filter);
    });
  }

  // Filter posts by type
  Future<void> filterPosts(PostType? newFilter) async {
    if (newFilter == filter) return;
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
          .getLatestPosts(searchQuery: query, filter: filter);
    });
  }

  // Get popular posts
  Future<void> loadPopularPosts() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getPopularPosts(filter: filter);
    });
  }
}
