// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'location_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Provider for managing user location and automatic location detection
@ProviderFor(LocationManager)
const locationManagerProvider = LocationManagerProvider._();

/// Provider for managing user location and automatic location detection
final class LocationManagerProvider
    extends $AsyncNotifierProvider<LocationManager, LocationState> {
  /// Provider for managing user location and automatic location detection
  const LocationManagerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'locationManagerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$locationManagerHash();

  @$internal
  @override
  LocationManager create() => LocationManager();
}

String _$locationManagerHash() => r'79aa642dc75c870aa9513dbb84458d3d49d52ba3';

abstract class _$LocationManager extends $AsyncNotifier<LocationState> {
  FutureOr<LocationState> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<LocationState>, LocationState>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<LocationState>, LocationState>,
              AsyncValue<LocationState>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
