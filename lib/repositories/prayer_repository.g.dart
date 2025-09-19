// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(PrayerRepository)
const prayerRepositoryProvider = PrayerRepositoryProvider._();

final class PrayerRepositoryProvider
    extends $AsyncNotifierProvider<PrayerRepository, void> {
  const PrayerRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prayerRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prayerRepositoryHash();

  @$internal
  @override
  PrayerRepository create() => PrayerRepository();
}

String _$prayerRepositoryHash() => r'87469f8fdbf31f2d40895ea6740e449a6d97e62a';

abstract class _$PrayerRepository extends $AsyncNotifier<void> {
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
