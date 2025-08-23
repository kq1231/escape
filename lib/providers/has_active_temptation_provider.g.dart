// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'has_active_temptation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider to check if there's an active temptation
/// Used in AppStartupSuccessWidget to determine whether to show the banner
/// keepAlive: true because it's used during app startup and should persist
@ProviderFor(HasActiveTemptation)
const hasActiveTemptationProvider = HasActiveTemptationProvider._();

/// Provider to check if there's an active temptation
/// Used in AppStartupSuccessWidget to determine whether to show the banner
/// keepAlive: true because it's used during app startup and should persist
final class HasActiveTemptationProvider
    extends $NotifierProvider<HasActiveTemptation, bool> {
  /// Provider to check if there's an active temptation
  /// Used in AppStartupSuccessWidget to determine whether to show the banner
  /// keepAlive: true because it's used during app startup and should persist
  const HasActiveTemptationProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'hasActiveTemptationProvider',
        isAutoDispose: false,
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
    r'2148bcef091793116041d839471a51018efb677b';

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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
