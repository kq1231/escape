import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/posts_repository.dart';
import '../models/post_model.dart';

part 'post_provider.g.dart';

@Riverpod()
class PostProvider extends _$PostProvider {
  @override
  Future<Post> build(String postId) async {
    return await ref
        .read(postsRepositoryProvider.notifier)
        .getPostWithViewIncrement(postId);
  }
}
