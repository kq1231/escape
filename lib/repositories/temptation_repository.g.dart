// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temptation_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(TemptationRepository)
const temptationRepositoryProvider = TemptationRepositoryProvider._();

final class TemptationRepositoryProvider
    extends $AsyncNotifierProvider<TemptationRepository, void> {
  const TemptationRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temptationRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temptationRepositoryHash();

  @$internal
  @override
  TemptationRepository create() => TemptationRepository();
}

String _$temptationRepositoryHash() =>
    r'4731af901bc7c474d5e7d1de05f0405c25f9c867';

abstract class _$TemptationRepository extends $AsyncNotifier<void> {
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
