// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_repository_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles all challenge-related operations
/// This repository manages challenges and their validation logic
@ProviderFor(ChallengesRepository)
const challengesRepositoryProvider = ChallengesRepositoryProvider._();

/// A provider that handles all challenge-related operations
/// This repository manages challenges and their validation logic
final class ChallengesRepositoryProvider
    extends $AsyncNotifierProvider<ChallengesRepository, void> {
  /// A provider that handles all challenge-related operations
  /// This repository manages challenges and their validation logic
  const ChallengesRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengesRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengesRepositoryHash();

  @$internal
  @override
  ChallengesRepository create() => ChallengesRepository();
}

String _$challengesRepositoryHash() =>
    r'8cd90e173e366b6d57f9289e24fabeab8af496d8';

abstract class _$ChallengesRepository extends $AsyncNotifier<void> {
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
