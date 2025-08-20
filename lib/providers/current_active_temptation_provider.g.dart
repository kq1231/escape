// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'current_active_temptation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for the current active temptation (if any)
/// Used in the temptation flow screen to manage temptation state
/// keepAlive: false because it's only used during active temptation sessions
@ProviderFor(CurrentActiveTemptation)
const currentActiveTemptationProvider = CurrentActiveTemptationProvider._();

/// Provider for the current active temptation (if any)
/// Used in the temptation flow screen to manage temptation state
/// keepAlive: false because it's only used during active temptation sessions
final class CurrentActiveTemptationProvider
    extends $AsyncNotifierProvider<CurrentActiveTemptation, Temptation?> {
  /// Provider for the current active temptation (if any)
  /// Used in the temptation flow screen to manage temptation state
  /// keepAlive: false because it's only used during active temptation sessions
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
}

String _$currentActiveTemptationHash() =>
    r'2617975d3d4961953b93ed3389c2d4ae5cb1a761';

abstract class _$CurrentActiveTemptation extends $AsyncNotifier<Temptation?> {
  FutureOr<Temptation?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Temptation?>, Temptation?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Temptation?>, Temptation?>,
              AsyncValue<Temptation?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
