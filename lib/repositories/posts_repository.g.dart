// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostsRepository)
const postsRepositoryProvider = PostsRepositoryProvider._();

final class PostsRepositoryProvider
    extends $AsyncNotifierProvider<PostsRepository, bool> {
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

String _$postsRepositoryHash() => r'8d09b85eba733375f7bd30197cbded226e0b97d0';

abstract class _$PostsRepository extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
