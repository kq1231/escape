// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quick_stats_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(QuickStats)
const quickStatsProvider = QuickStatsProvider._();

final class QuickStatsProvider
    extends $StreamNotifierProvider<QuickStats, quick_stats.QuickStats> {
  const QuickStatsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'quickStatsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$quickStatsHash();

  @$internal
  @override
  QuickStats create() => QuickStats();
}

String _$quickStatsHash() => r'847faeab8389c769b2a49f2bca0cb3639f1e857d';

abstract class _$QuickStats extends $StreamNotifier<quick_stats.QuickStats> {
  Stream<quick_stats.QuickStats> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<quick_stats.QuickStats>, quick_stats.QuickStats>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<quick_stats.QuickStats>,
                quick_stats.QuickStats
              >,
              AsyncValue<quick_stats.QuickStats>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
