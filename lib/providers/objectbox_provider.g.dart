// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'objectbox_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(objectbox)
const objectboxProvider = ObjectboxProvider._();

final class ObjectboxProvider
    extends
        $FunctionalProvider<
          AsyncValue<ObjectBox>,
          ObjectBox,
          FutureOr<ObjectBox>
        >
    with $FutureModifier<ObjectBox>, $FutureProvider<ObjectBox> {
  const ObjectboxProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'objectboxProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$objectboxHash();

  @$internal
  @override
  $FutureProviderElement<ObjectBox> $createElement($ProviderPointer pointer) =>
      $FutureProviderElement(pointer);

  @override
  FutureOr<ObjectBox> create(Ref ref) {
    return objectbox(ref);
  }
}

String _$objectboxHash() => r'0018b4fbb5cc51bf7afe8e6f3076c3a90621d794';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
