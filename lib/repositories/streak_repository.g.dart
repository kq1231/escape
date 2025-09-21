// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(StreakRepository)
const streakRepositoryProvider = StreakRepositoryProvider._();

final class StreakRepositoryProvider
    extends $AsyncNotifierProvider<StreakRepository, void> {
  const StreakRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'streakRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$streakRepositoryHash();

  @$internal
  @override
  StreakRepository create() => StreakRepository();
}

String _$streakRepositoryHash() => r'b7ed2aefd8008d589f3cf2af37fb1eed6c6edf2e';

abstract class _$StreakRepository extends $AsyncNotifier<void> {
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
