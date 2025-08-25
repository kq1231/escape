// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(XPRepository)
const xPRepositoryProvider = XPRepositoryProvider._();

final class XPRepositoryProvider
    extends $AsyncNotifierProvider<XPRepository, void> {
  const XPRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xPRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xPRepositoryHash();

  @$internal
  @override
  XPRepository create() => XPRepository();
}

String _$xPRepositoryHash() => r'584501884c7ff769eccae8e2a9ec060a86f08996';

abstract class _$XPRepository extends $AsyncNotifier<void> {
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
