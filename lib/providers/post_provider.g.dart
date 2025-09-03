// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PostProvider)
const postProviderProvider = PostProviderFamily._();

final class PostProviderProvider
    extends $AsyncNotifierProvider<PostProvider, Post> {
  const PostProviderProvider._({
    required PostProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'postProviderProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$postProviderHash();

  @override
  String toString() {
    return r'postProviderProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PostProvider create() => PostProvider();

  @override
  bool operator ==(Object other) {
    return other is PostProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$postProviderHash() => r'8eec9ca62584b0868f3c3a57bd8d7f457526aa86';

final class PostProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          PostProvider,
          AsyncValue<Post>,
          Post,
          FutureOr<Post>,
          String
        > {
  const PostProviderFamily._()
    : super(
        retry: null,
        name: r'postProviderProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PostProviderProvider call(String postId) =>
      PostProviderProvider._(argument: postId, from: this);

  @override
  String toString() => r'postProviderProvider';
}

abstract class _$PostProvider extends $AsyncNotifier<Post> {
  late final _$args = ref.$arg as String;
  String get postId => _$args;

  FutureOr<Post> build(String postId);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<Post>, Post>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Post>, Post>,
              AsyncValue<Post>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
