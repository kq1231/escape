// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'posts_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostsProvider)
const postsProviderProvider = PostsProviderFamily._();

final class PostsProviderProvider
    extends $AsyncNotifierProvider<PostsProvider, List<PostPreview>> {
  const PostsProviderProvider._({
    required PostsProviderFamily super.from,
    required PostType? super.argument,
  }) : super(
         retry: null,
         name: r'postsProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postsProviderHash();

  @override
  String toString() {
    return r'postsProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostsProvider create() => PostsProvider();

  @override
  bool operator ==(Object other) {
    return other is PostsProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postsProviderHash() => r'fc0c6662d6c543acfb855994a2515c33f926560e';

final class PostsProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          PostsProvider,
          AsyncValue<List<PostPreview>>,
          List<PostPreview>,
          FutureOr<List<PostPreview>>,
          PostType?
        > {
  const PostsProviderFamily._()
    : super(
        retry: null,
        name: r'postsProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostsProviderProvider call({PostType? filter}) =>
      PostsProviderProvider._(argument: filter, from: this);

  @override
  String toString() => r'postsProviderProvider';
}

abstract class _$PostsProvider extends $AsyncNotifier<List<PostPreview>> {
  late final _$args = ref.$arg as PostType?;
  PostType? get filter => _$args;

  FutureOr<List<PostPreview>> build({PostType? filter});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(filter: _$args);
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
