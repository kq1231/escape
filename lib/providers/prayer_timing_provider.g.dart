// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_timing_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that fetches and provides prayer timings.
/// It reads user preferences from Shared Preferences to determine
/// the location and calculation method.
@ProviderFor(PrayerTiming)
const prayerTimingProvider = PrayerTimingProvider._();

/// A provider that fetches and provides prayer timings.
/// It reads user preferences from Shared Preferences to determine
/// the location and calculation method.
final class PrayerTimingProvider
    extends $AsyncNotifierProvider<PrayerTiming, PrayerTimes?> {
  /// A provider that fetches and provides prayer timings.
  /// It reads user preferences from Shared Preferences to determine
  /// the location and calculation method.
  const PrayerTimingProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'prayerTimingProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$prayerTimingHash();

  @$internal
  @override
  PrayerTiming create() => PrayerTiming();
}

String _$prayerTimingHash() => r'5d5ddaa158b46472d932f8b4108c8684020cbcff';

abstract class _$PrayerTiming extends $AsyncNotifier<PrayerTimes?> {
  FutureOr<PrayerTimes?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PrayerTimes?>, PrayerTimes?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PrayerTimes?>, PrayerTimes?>,
              AsyncValue<PrayerTimes?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
