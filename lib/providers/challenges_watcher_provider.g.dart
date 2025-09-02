// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'challenges_watcher_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(ChallengesWatcher)
const challengesWatcherProvider = ChallengesWatcherProvider._();

final class ChallengesWatcherProvider
    extends $StreamNotifierProvider<ChallengesWatcher, List<Challenge>> {
  const ChallengesWatcherProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'challengesWatcherProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$challengesWatcherHash();

  @$internal
  @override
  ChallengesWatcher create() => ChallengesWatcher();
}

String _$challengesWatcherHash() => r'f916359ccec844aead8453ce20ebda02d109e8be';

abstract class _$ChallengesWatcher extends $StreamNotifier<List<Challenge>> {
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
