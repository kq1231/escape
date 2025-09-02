// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that manages challenges by combining hardcoded challenges with database challenges
/// This provider watches for challenges from the database and merges them with hardcoded challenges
@ProviderFor(Challenges)
const challengesProvider = ChallengesProvider._();

/// A provider that manages challenges by combining hardcoded challenges with database challenges
/// This provider watches for challenges from the database and merges them with hardcoded challenges
final class ChallengesProvider
    extends $StreamNotifierProvider<Challenges, List<Challenge>> {
  /// A provider that manages challenges by combining hardcoded challenges with database challenges
  /// This provider watches for challenges from the database and merges them with hardcoded challenges
  const ChallengesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengesProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengesHash();

  @$internal
  @override
  Challenges create() => Challenges();
}

String _$challengesHash() => r'7296c4d527c512fc29358cd937214c0f4320522f';

abstract class _$Challenges extends $StreamNotifier<List<Challenge>> {
  Stream<List<Challenge>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Challenge>>, List<Challenge>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Challenge>>, List<Challenge>>,
              AsyncValue<List<Challenge>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
