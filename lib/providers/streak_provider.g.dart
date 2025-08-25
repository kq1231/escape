// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'streak_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles all streak-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@ProviderFor(TodaysStreak)
const todaysStreakProvider = TodaysStreakProvider._();

/// A provider that handles all streak-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
final class TodaysStreakProvider
    extends $StreamNotifierProvider<TodaysStreak, Streak?> {
  /// A provider that handles all streak-related operations
  /// This provider has keepAlive: false (autoDispose) for efficiency
  const TodaysStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysStreakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysStreakHash();

  @$internal
  @override
  TodaysStreak create() => TodaysStreak();
}

String _$todaysStreakHash() => r'2419dfd8c4e5b9ca9ccfb8c5db80d2d43c6186ad';

abstract class _$TodaysStreak extends $StreamNotifier<Streak?> {
  Stream<Streak?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Streak?>, Streak?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Streak?>, Streak?>,
              AsyncValue<Streak?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// A provider that exclusively watches the latest streak
@ProviderFor(latestStreak)
const latestStreakProvider = LatestStreakProvider._();

/// A provider that exclusively watches the latest streak
final class LatestStreakProvider
    extends $FunctionalProvider<AsyncValue<Streak?>, Streak?, Stream<Streak?>>
    with $FutureModifier<Streak?>, $StreamProvider<Streak?> {
  /// A provider that exclusively watches the latest streak
  const LatestStreakProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'latestStreakProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$latestStreakHash();

  @$internal
  @override
  $StreamProviderElement<Streak?> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Streak?> create(Ref ref) {
    return latestStreak(ref);
  }
}

String _$latestStreakHash() => r'08d06b8e7118e47ab081885bb06559f178d3ae52';

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
