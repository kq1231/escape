// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostsRepository)
const postsRepositoryProvider = PostsRepositoryProvider._();

final class PostsRepositoryProvider
    extends $AsyncNotifierProvider<PostsRepository, void> {
  const PostsRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsRepositoryHash();

  @$internal
  @override
  PostsRepository create() => PostsRepository();
}

String _$postsRepositoryHash() => r'4e6e5aa0046bab54c67a55f1b3882f2e20759b48';

abstract class _$PostsRepository extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
