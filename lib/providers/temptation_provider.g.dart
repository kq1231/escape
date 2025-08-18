// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'temptation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles all temptation-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@ProviderFor(ActiveTemptations)
const activeTemptationsProvider = ActiveTemptationsProvider._();

/// A provider that handles all temptation-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
final class ActiveTemptationsProvider
    extends $StreamNotifierProvider<ActiveTemptations, List<Temptation>> {
  /// A provider that handles all temptation-related operations
  /// This provider has keepAlive: false (autoDispose) for efficiency
  const ActiveTemptationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'activeTemptationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$activeTemptationsHash();

  @$internal
  @override
  ActiveTemptations create() => ActiveTemptations();
}

String _$activeTemptationsHash() => r'c2d991591ef2f7fc15e908a836a74e4a26f6db60';

abstract class _$ActiveTemptations extends $StreamNotifier<List<Temptation>> {
  Stream<List<Temptation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Temptation>>, List<Temptation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Temptation>>, List<Temptation>>,
              AsyncValue<List<Temptation>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for all temptations history
@ProviderFor(AllTemptations)
const allTemptationsProvider = AllTemptationsProvider._();

/// Provider for all temptations history
final class AllTemptationsProvider
    extends $StreamNotifierProvider<AllTemptations, List<Temptation>> {
  /// Provider for all temptations history
  const AllTemptationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'allTemptationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$allTemptationsHash();

  @$internal
  @override
  AllTemptations create() => AllTemptations();
}

String _$allTemptationsHash() => r'74310942f39832e8f828eacfd0a8ffa09b44cb00';

abstract class _$AllTemptations extends $StreamNotifier<List<Temptation>> {
  Stream<List<Temptation>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<Temptation>>, List<Temptation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Temptation>>, List<Temptation>>,
              AsyncValue<List<Temptation>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for today's temptations
@ProviderFor(TodaysTemptations)
const todaysTemptationsProvider = TodaysTemptationsProvider._();

/// Provider for today's temptations
final class TodaysTemptationsProvider
    extends $NotifierProvider<TodaysTemptations, List<Temptation>> {
  /// Provider for today's temptations
  const TodaysTemptationsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'todaysTemptationsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$todaysTemptationsHash();

  @$internal
  @override
  TodaysTemptations create() => TodaysTemptations();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<Temptation> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<Temptation>>(value),
    );
  }
}

String _$todaysTemptationsHash() => r'c923ab96ee3a9f6c9d34e0e5f505d524ce0bbc8a';

abstract class _$TodaysTemptations extends $Notifier<List<Temptation>> {
  List<Temptation> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<Temptation>, List<Temptation>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<Temptation>, List<Temptation>>,
              List<Temptation>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for temptation statistics
@ProviderFor(TemptationStats)
const temptationStatsProvider = TemptationStatsProvider._();

/// Provider for temptation statistics
final class TemptationStatsProvider
    extends $AsyncNotifierProvider<TemptationStats, Map<String, dynamic>> {
  /// Provider for temptation statistics
  const TemptationStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'temptationStatsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$temptationStatsHash();

  @$internal
  @override
  TemptationStats create() => TemptationStats();
}

String _$temptationStatsHash() => r'70b378cd3c8cbd1794c338c7da6e4b39c22c74db';

abstract class _$TemptationStats extends $AsyncNotifier<Map<String, dynamic>> {
  FutureOr<Map<String, dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>>,
                Map<String, dynamic>
              >,
              AsyncValue<Map<String, dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for checking if there's an active temptation
@ProviderFor(HasActiveTemptation)
const hasActiveTemptationProvider = HasActiveTemptationProvider._();

/// Provider for checking if there's an active temptation
final class HasActiveTemptationProvider
    extends $NotifierProvider<HasActiveTemptation, bool> {
  /// Provider for checking if there's an active temptation
  const HasActiveTemptationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasActiveTemptationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$hasActiveTemptationHash();

  @$internal
  @override
  HasActiveTemptation create() => HasActiveTemptation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$hasActiveTemptationHash() =>
    r'a0da1ed427c8a35e29f438cbc86a9ff21c2be91d';

abstract class _$HasActiveTemptation extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for the current active temptation (if any)
@ProviderFor(CurrentActiveTemptation)
const currentActiveTemptationProvider = CurrentActiveTemptationProvider._();

/// Provider for the current active temptation (if any)
final class CurrentActiveTemptationProvider
    extends $NotifierProvider<CurrentActiveTemptation, Temptation?> {
  /// Provider for the current active temptation (if any)
  const CurrentActiveTemptationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currentActiveTemptationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currentActiveTemptationHash();

  @$internal
  @override
  CurrentActiveTemptation create() => CurrentActiveTemptation();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Temptation? value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Temptation?>(value),
    );
  }
}

String _$currentActiveTemptationHash() =>
    r'f450bdf15845b2c01d5c32e6890d1e635dcc27a1';

abstract class _$CurrentActiveTemptation extends $Notifier<Temptation?> {
  Temptation? build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Temptation?, Temptation?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Temptation?, Temptation?>,
              Temptation?,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

/// Provider for creating a new temptation
@ProviderFor(CreateTemptation)
const createTemptationProvider = CreateTemptationProvider._();

/// Provider for creating a new temptation
final class CreateTemptationProvider
    extends $AsyncNotifierProvider<CreateTemptation, Temptation> {
  /// Provider for creating a new temptation
  const CreateTemptationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'createTemptationProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$createTemptationHash();

  @$internal
  @override
  CreateTemptation create() => CreateTemptation();
}

String _$createTemptationHash() => r'47f5c1d861b38b5eb98ec3e43cfb7576382a1347';

abstract class _$CreateTemptation extends $AsyncNotifier<Temptation> {
  FutureOr<Temptation> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Temptation>, Temptation>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Temptation>, Temptation>,
              AsyncValue<Temptation>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
