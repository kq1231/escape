// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_startup_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles app initialization and manages the app startup state
@ProviderFor(AppStartup)
const appStartupProvider = AppStartupProvider._();

/// A provider that handles app initialization and manages the app startup state
final class AppStartupProvider
    extends $AsyncNotifierProvider<AppStartup, bool> {
  /// A provider that handles app initialization and manages the app startup state
  const AppStartupProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appStartupProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appStartupHash();

  @$internal
  @override
  AppStartup create() => AppStartup();
}

String _$appStartupHash() => r'489ef9f3f8c020468e4c4bd19cab52a0f4b6c206';

abstract class _$AppStartup extends $AsyncNotifier<bool> {
  FutureOr<bool> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<bool>, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<bool>, bool>,
              AsyncValue<bool>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
