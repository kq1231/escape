import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/posts_repository.dart';
import '../models/post_model.dart';

part 'posts_provider.g.dart';

@Riverpod()
class PostsProvider extends _$PostsProvider {
  @override
  Future<List<PostPreview>> build({PostType? filter}) async {
    return await AsyncValue.guard(() async {
      return await ref
          .read(postsRepositoryProvider.notifier)
          .getLatestPosts(filter: filter);
    }).then((value) => value.requireValue);
  }

  // Load more posts
  Future<void> loadMorePosts() async {
    final currentPosts = await future;
    final currentOffset = currentPosts.length;
    final hasMore = await ref
        .read(postsRepositoryProvider.notifier)
        .hasMorePosts(offset: currentOffset, filter: filter, limit: 10);

    if (!hasMore) return;

    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final newPosts = await ref
          .read(postsRepositoryProvider.notifier)
          .getLatestPosts(offset: currentOffset, filter: filter);
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
