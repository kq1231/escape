// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostsProvider)
const postsProviderProvider = PostsProviderProvider._();

final class PostsProviderProvider
    extends $AsyncNotifierProvider<PostsProvider, List<PostPreview>> {
  const PostsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'postsProviderProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$postsProviderHash();

  @$internal
  @override
  PostsProvider create() => PostsProvider();
}

String _$postsProviderHash() => r'ae474a0fa4f75ba7dc424faf40d1215003f49d8f';

abstract class _$PostsProvider extends $AsyncNotifier<List<PostPreview>> {
  FutureOr<List<PostPreview>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<PostPreview>>, List<PostPreview>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<PostPreview>>, List<PostPreview>>,
              AsyncValue<List<PostPreview>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
