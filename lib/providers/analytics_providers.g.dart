// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'analytics_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// Streak Analytics Providers
/// Provider for streak contribution grid data (GitHub-style activity grid)
@ProviderFor(streakGridData)
const streakGridDataProvider = StreakGridDataFamily._();

/// Streak Analytics Providers
/// Provider for streak contribution grid data (GitHub-style activity grid)
final class StreakGridDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<StreakGridData>>,
          List<StreakGridData>,
          FutureOr<List<StreakGridData>>
        >
    with
        $FutureModifier<List<StreakGridData>>,
        $FutureProvider<List<StreakGridData>> {
  /// Streak Analytics Providers
  /// Provider for streak contribution grid data (GitHub-style activity grid)
  const StreakGridDataProvider._({
    required StreakGridDataFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'streakGridDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$streakGridDataHash();

  @override
  String toString() {
    return r'streakGridDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<StreakGridData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<StreakGridData>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return streakGridData(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StreakGridDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streakGridDataHash() => r'c17612c540f8b472133482381ac90d8543813d58';

/// Streak Analytics Providers
/// Provider for streak contribution grid data (GitHub-style activity grid)
final class StreakGridDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<StreakGridData>>,
          AnalyticsTimeRange?
        > {
  const StreakGridDataFamily._()
    : super(
        retry: null,
        name: r'streakGridDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Streak Analytics Providers
  /// Provider for streak contribution grid data (GitHub-style activity grid)
  StreakGridDataProvider call({AnalyticsTimeRange? range}) =>
      StreakGridDataProvider._(argument: range, from: this);

  @override
  String toString() => r'streakGridDataProvider';
}

/// Provider for streak progress data for line chart
@ProviderFor(streakProgressData)
const streakProgressDataProvider = StreakProgressDataFamily._();

/// Provider for streak progress data for line chart
final class StreakProgressDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Map<String, dynamic>>>,
          List<Map<String, dynamic>>,
          FutureOr<List<Map<String, dynamic>>>
        >
    with
        $FutureModifier<List<Map<String, dynamic>>>,
        $FutureProvider<List<Map<String, dynamic>>> {
  /// Provider for streak progress data for line chart
  const StreakProgressDataProvider._({
    required StreakProgressDataFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'streakProgressDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$streakProgressDataHash();

  @override
  String toString() {
    return r'streakProgressDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<Map<String, dynamic>>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<Map<String, dynamic>>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return streakProgressData(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StreakProgressDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streakProgressDataHash() =>
    r'1812bacfe09b8302bce2ee349a5b15b263253d2c';

/// Provider for streak progress data for line chart
final class StreakProgressDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<Map<String, dynamic>>>,
          AnalyticsTimeRange?
        > {
  const StreakProgressDataFamily._()
    : super(
        retry: null,
        name: r'streakProgressDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for streak progress data for line chart
  StreakProgressDataProvider call({AnalyticsTimeRange? range}) =>
      StreakProgressDataProvider._(argument: range, from: this);

  @override
  String toString() => r'streakProgressDataProvider';
}

/// Provider for streak statistics
@ProviderFor(streakStatistics)
const streakStatisticsProvider = StreakStatisticsFamily._();

/// Provider for streak statistics
final class StreakStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<StreakStatistics>,
          StreakStatistics,
          FutureOr<StreakStatistics>
        >
    with $FutureModifier<StreakStatistics>, $FutureProvider<StreakStatistics> {
  /// Provider for streak statistics
  const StreakStatisticsProvider._({
    required StreakStatisticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'streakStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$streakStatisticsHash();

  @override
  String toString() {
    return r'streakStatisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<StreakStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<StreakStatistics> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return streakStatistics(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is StreakStatisticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streakStatisticsHash() => r'b5ae10c70f96cee01719b55fa4563cc9fef9134c';

/// Provider for streak statistics
final class StreakStatisticsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<StreakStatistics>,
          AnalyticsTimeRange?
        > {
  const StreakStatisticsFamily._()
    : super(
        retry: null,
        name: r'streakStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for streak statistics
  StreakStatisticsProvider call({AnalyticsTimeRange? range}) =>
      StreakStatisticsProvider._(argument: range, from: this);

  @override
  String toString() => r'streakStatisticsProvider';
}

/// Prayer Analytics Providers
/// Provider for prayer completion grid data
@ProviderFor(prayerGridData)
const prayerGridDataProvider = PrayerGridDataFamily._();

/// Prayer Analytics Providers
/// Provider for prayer completion grid data
final class PrayerGridDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<PrayerGridData>>,
          List<PrayerGridData>,
          FutureOr<List<PrayerGridData>>
        >
    with
        $FutureModifier<List<PrayerGridData>>,
        $FutureProvider<List<PrayerGridData>> {
  /// Prayer Analytics Providers
  /// Provider for prayer completion grid data
  const PrayerGridDataProvider._({
    required PrayerGridDataFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'prayerGridDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prayerGridDataHash();

  @override
  String toString() {
    return r'prayerGridDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<PrayerGridData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<PrayerGridData>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return prayerGridData(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PrayerGridDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prayerGridDataHash() => r'80f89d9ce7f7bca0013b3da178f9e86d160a8f18';

/// Prayer Analytics Providers
/// Provider for prayer completion grid data
final class PrayerGridDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<PrayerGridData>>,
          AnalyticsTimeRange?
        > {
  const PrayerGridDataFamily._()
    : super(
        retry: null,
        name: r'prayerGridDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Prayer Analytics Providers
  /// Provider for prayer completion grid data
  PrayerGridDataProvider call({AnalyticsTimeRange? range}) =>
      PrayerGridDataProvider._(argument: range, from: this);

  @override
  String toString() => r'prayerGridDataProvider';
}

/// Provider for prayer completion breakdown by prayer type
@ProviderFor(prayerBreakdown)
const prayerBreakdownProvider = PrayerBreakdownFamily._();

/// Provider for prayer completion breakdown by prayer type
final class PrayerBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<Map<String, int>>,
          Map<String, int>,
          FutureOr<Map<String, int>>
        >
    with $FutureModifier<Map<String, int>>, $FutureProvider<Map<String, int>> {
  /// Provider for prayer completion breakdown by prayer type
  const PrayerBreakdownProvider._({
    required PrayerBreakdownFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'prayerBreakdownProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prayerBreakdownHash();

  @override
  String toString() {
    return r'prayerBreakdownProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<Map<String, int>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<Map<String, int>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return prayerBreakdown(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PrayerBreakdownProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prayerBreakdownHash() => r'72814d9aa00e58ef9a3b7f1ff1cb499a21d32bb3';

/// Provider for prayer completion breakdown by prayer type
final class PrayerBreakdownFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<Map<String, int>>,
          AnalyticsTimeRange?
        > {
  const PrayerBreakdownFamily._()
    : super(
        retry: null,
        name: r'prayerBreakdownProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for prayer completion breakdown by prayer type
  PrayerBreakdownProvider call({AnalyticsTimeRange? range}) =>
      PrayerBreakdownProvider._(argument: range, from: this);

  @override
  String toString() => r'prayerBreakdownProvider';
}

/// Provider for prayer statistics
@ProviderFor(prayerStatistics)
const prayerStatisticsProvider = PrayerStatisticsFamily._();

/// Provider for prayer statistics
final class PrayerStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<PrayerStatistics>,
          PrayerStatistics,
          FutureOr<PrayerStatistics>
        >
    with $FutureModifier<PrayerStatistics>, $FutureProvider<PrayerStatistics> {
  /// Provider for prayer statistics
  const PrayerStatisticsProvider._({
    required PrayerStatisticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'prayerStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prayerStatisticsHash();

  @override
  String toString() {
    return r'prayerStatisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<PrayerStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PrayerStatistics> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return prayerStatistics(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is PrayerStatisticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prayerStatisticsHash() => r'a0b54942ffa6200258aeed3a33cb59db6a4586e0';

/// Provider for prayer statistics
final class PrayerStatisticsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<PrayerStatistics>,
          AnalyticsTimeRange?
        > {
  const PrayerStatisticsFamily._()
    : super(
        retry: null,
        name: r'prayerStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for prayer statistics
  PrayerStatisticsProvider call({AnalyticsTimeRange? range}) =>
      PrayerStatisticsProvider._(argument: range, from: this);

  @override
  String toString() => r'prayerStatisticsProvider';
}

/// Temptation Analytics Providers
/// Provider for temptation bar chart data (stacked bar chart)
@ProviderFor(temptationBarData)
const temptationBarDataProvider = TemptationBarDataFamily._();

/// Temptation Analytics Providers
/// Provider for temptation bar chart data (stacked bar chart)
final class TemptationBarDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<TemptationBarData>>,
          List<TemptationBarData>,
          FutureOr<List<TemptationBarData>>
        >
    with
        $FutureModifier<List<TemptationBarData>>,
        $FutureProvider<List<TemptationBarData>> {
  /// Temptation Analytics Providers
  /// Provider for temptation bar chart data (stacked bar chart)
  const TemptationBarDataProvider._({
    required TemptationBarDataFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'temptationBarDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$temptationBarDataHash();

  @override
  String toString() {
    return r'temptationBarDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<TemptationBarData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<TemptationBarData>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return temptationBarData(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TemptationBarDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$temptationBarDataHash() => r'247b23fe1d33d03d647baed481e0af22ff47a9c8';

/// Temptation Analytics Providers
/// Provider for temptation bar chart data (stacked bar chart)
final class TemptationBarDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<TemptationBarData>>,
          AnalyticsTimeRange?
        > {
  const TemptationBarDataFamily._()
    : super(
        retry: null,
        name: r'temptationBarDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Temptation Analytics Providers
  /// Provider for temptation bar chart data (stacked bar chart)
  TemptationBarDataProvider call({AnalyticsTimeRange? range}) =>
      TemptationBarDataProvider._(argument: range, from: this);

  @override
  String toString() => r'temptationBarDataProvider';
}

/// Provider for temptation statistics
@ProviderFor(temptationStatistics)
const temptationStatisticsProvider = TemptationStatisticsFamily._();

/// Provider for temptation statistics
final class TemptationStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<TemptationStatistics>,
          TemptationStatistics,
          FutureOr<TemptationStatistics>
        >
    with
        $FutureModifier<TemptationStatistics>,
        $FutureProvider<TemptationStatistics> {
  /// Provider for temptation statistics
  const TemptationStatisticsProvider._({
    required TemptationStatisticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'temptationStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$temptationStatisticsHash();

  @override
  String toString() {
    return r'temptationStatisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<TemptationStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<TemptationStatistics> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return temptationStatistics(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is TemptationStatisticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$temptationStatisticsHash() =>
    r'39581c1eaa69ce2ca8a77249969540907f556a22';

/// Provider for temptation statistics
final class TemptationStatisticsFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<TemptationStatistics>,
          AnalyticsTimeRange?
        > {
  const TemptationStatisticsFamily._()
    : super(
        retry: null,
        name: r'temptationStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for temptation statistics
  TemptationStatisticsProvider call({AnalyticsTimeRange? range}) =>
      TemptationStatisticsProvider._(argument: range, from: this);

  @override
  String toString() => r'temptationStatisticsProvider';
}

/// XP Analytics Providers
/// Provider for XP growth data for line chart (cumulative and daily)
@ProviderFor(xpGrowthData)
const xpGrowthDataProvider = XpGrowthDataFamily._();

/// XP Analytics Providers
/// Provider for XP growth data for line chart (cumulative and daily)
final class XpGrowthDataProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<XPGrowthData>>,
          List<XPGrowthData>,
          FutureOr<List<XPGrowthData>>
        >
    with
        $FutureModifier<List<XPGrowthData>>,
        $FutureProvider<List<XPGrowthData>> {
  /// XP Analytics Providers
  /// Provider for XP growth data for line chart (cumulative and daily)
  const XpGrowthDataProvider._({
    required XpGrowthDataFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'xpGrowthDataProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$xpGrowthDataHash();

  @override
  String toString() {
    return r'xpGrowthDataProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<XPGrowthData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<XPGrowthData>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return xpGrowthData(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is XpGrowthDataProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$xpGrowthDataHash() => r'67a95b8a8155e7e57ef6ac6ca47e4e2a64bab986';

/// XP Analytics Providers
/// Provider for XP growth data for line chart (cumulative and daily)
final class XpGrowthDataFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<XPGrowthData>>,
          AnalyticsTimeRange?
        > {
  const XpGrowthDataFamily._()
    : super(
        retry: null,
        name: r'xpGrowthDataProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// XP Analytics Providers
  /// Provider for XP growth data for line chart (cumulative and daily)
  XpGrowthDataProvider call({AnalyticsTimeRange? range}) =>
      XpGrowthDataProvider._(argument: range, from: this);

  @override
  String toString() => r'xpGrowthDataProvider';
}

/// Provider for XP source breakdown for pie chart
@ProviderFor(xpSourceBreakdown)
const xpSourceBreakdownProvider = XpSourceBreakdownFamily._();

/// Provider for XP source breakdown for pie chart
final class XpSourceBreakdownProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<XPSourceData>>,
          List<XPSourceData>,
          FutureOr<List<XPSourceData>>
        >
    with
        $FutureModifier<List<XPSourceData>>,
        $FutureProvider<List<XPSourceData>> {
  /// Provider for XP source breakdown for pie chart
  const XpSourceBreakdownProvider._({
    required XpSourceBreakdownFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'xpSourceBreakdownProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$xpSourceBreakdownHash();

  @override
  String toString() {
    return r'xpSourceBreakdownProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<List<XPSourceData>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<XPSourceData>> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return xpSourceBreakdown(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is XpSourceBreakdownProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$xpSourceBreakdownHash() => r'7dfde5bd4f9e6951f4551f84edca0e457f7b9db7';

/// Provider for XP source breakdown for pie chart
final class XpSourceBreakdownFamily extends $Family
    with
        $FunctionalFamilyOverride<
          FutureOr<List<XPSourceData>>,
          AnalyticsTimeRange?
        > {
  const XpSourceBreakdownFamily._()
    : super(
        retry: null,
        name: r'xpSourceBreakdownProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for XP source breakdown for pie chart
  XpSourceBreakdownProvider call({AnalyticsTimeRange? range}) =>
      XpSourceBreakdownProvider._(argument: range, from: this);

  @override
  String toString() => r'xpSourceBreakdownProvider';
}

/// Provider for XP statistics
@ProviderFor(xpStatistics)
const xpStatisticsProvider = XpStatisticsFamily._();

/// Provider for XP statistics
final class XpStatisticsProvider
    extends
        $FunctionalProvider<
          AsyncValue<XPStatistics>,
          XPStatistics,
          FutureOr<XPStatistics>
        >
    with $FutureModifier<XPStatistics>, $FutureProvider<XPStatistics> {
  /// Provider for XP statistics
  const XpStatisticsProvider._({
    required XpStatisticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'xpStatisticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$xpStatisticsHash();

  @override
  String toString() {
    return r'xpStatisticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $FutureProviderElement<XPStatistics> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<XPStatistics> create(Ref ref) {
    final argument = this.argument as AnalyticsTimeRange?;
    return xpStatistics(ref, range: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is XpStatisticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$xpStatisticsHash() => r'db251e9495812f0d1bb826b5126d6463a88112a3';

/// Provider for XP statistics
final class XpStatisticsFamily extends $Family
    with
        $FunctionalFamilyOverride<FutureOr<XPStatistics>, AnalyticsTimeRange?> {
  const XpStatisticsFamily._()
    : super(
        retry: null,
        name: r'xpStatisticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for XP statistics
  XpStatisticsProvider call({AnalyticsTimeRange? range}) =>
      XpStatisticsProvider._(argument: range, from: this);

  @override
  String toString() => r'xpStatisticsProvider';
}

/// Combined Analytics Providers
/// Provider for all streak analytics data
@ProviderFor(StreakAnalytics)
const streakAnalyticsProvider = StreakAnalyticsFamily._();

/// Combined Analytics Providers
/// Provider for all streak analytics data
final class StreakAnalyticsProvider
    extends $AsyncNotifierProvider<StreakAnalytics, Map<String, dynamic>> {
  /// Combined Analytics Providers
  /// Provider for all streak analytics data
  const StreakAnalyticsProvider._({
    required StreakAnalyticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'streakAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$streakAnalyticsHash();

  @override
  String toString() {
    return r'streakAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  StreakAnalytics create() => StreakAnalytics();

  @override
  bool operator ==(Object other) {
    return other is StreakAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streakAnalyticsHash() => r'5bcb5759c8110ae8a850771b4052643487af4a3f';

/// Combined Analytics Providers
/// Provider for all streak analytics data
final class StreakAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
          StreakAnalytics,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          AnalyticsTimeRange?
        > {
  const StreakAnalyticsFamily._()
    : super(
        retry: null,
        name: r'streakAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Combined Analytics Providers
  /// Provider for all streak analytics data
  StreakAnalyticsProvider call({AnalyticsTimeRange? range}) =>
      StreakAnalyticsProvider._(argument: range, from: this);

  @override
  String toString() => r'streakAnalyticsProvider';
}

abstract class _$StreakAnalytics extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as AnalyticsTimeRange?;
  AnalyticsTimeRange? get range => _$args;

  FutureOr<Map<String, dynamic>> build({AnalyticsTimeRange? range});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(range: _$args);
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

/// Provider for all prayer analytics data
@ProviderFor(PrayerAnalytics)
const prayerAnalyticsProvider = PrayerAnalyticsFamily._();

/// Provider for all prayer analytics data
final class PrayerAnalyticsProvider
    extends $AsyncNotifierProvider<PrayerAnalytics, Map<String, dynamic>> {
  /// Provider for all prayer analytics data
  const PrayerAnalyticsProvider._({
    required PrayerAnalyticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'prayerAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prayerAnalyticsHash();

  @override
  String toString() {
    return r'prayerAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  PrayerAnalytics create() => PrayerAnalytics();

  @override
  bool operator ==(Object other) {
    return other is PrayerAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prayerAnalyticsHash() => r'7ef8534a534ce40e84d49abc0d706e6ec691b9a6';

/// Provider for all prayer analytics data
final class PrayerAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
          PrayerAnalytics,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          AnalyticsTimeRange?
        > {
  const PrayerAnalyticsFamily._()
    : super(
        retry: null,
        name: r'prayerAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for all prayer analytics data
  PrayerAnalyticsProvider call({AnalyticsTimeRange? range}) =>
      PrayerAnalyticsProvider._(argument: range, from: this);

  @override
  String toString() => r'prayerAnalyticsProvider';
}

abstract class _$PrayerAnalytics extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as AnalyticsTimeRange?;
  AnalyticsTimeRange? get range => _$args;

  FutureOr<Map<String, dynamic>> build({AnalyticsTimeRange? range});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(range: _$args);
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

/// Provider for all temptation analytics data
@ProviderFor(TemptationAnalytics)
const temptationAnalyticsProvider = TemptationAnalyticsFamily._();

/// Provider for all temptation analytics data
final class TemptationAnalyticsProvider
    extends $AsyncNotifierProvider<TemptationAnalytics, Map<String, dynamic>> {
  /// Provider for all temptation analytics data
  const TemptationAnalyticsProvider._({
    required TemptationAnalyticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'temptationAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$temptationAnalyticsHash();

  @override
  String toString() {
    return r'temptationAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TemptationAnalytics create() => TemptationAnalytics();

  @override
  bool operator ==(Object other) {
    return other is TemptationAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$temptationAnalyticsHash() =>
    r'c7e4799b79ad0ee8955106db74deb692f173d6e4';

/// Provider for all temptation analytics data
final class TemptationAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
          TemptationAnalytics,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          AnalyticsTimeRange?
        > {
  const TemptationAnalyticsFamily._()
    : super(
        retry: null,
        name: r'temptationAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for all temptation analytics data
  TemptationAnalyticsProvider call({AnalyticsTimeRange? range}) =>
      TemptationAnalyticsProvider._(argument: range, from: this);

  @override
  String toString() => r'temptationAnalyticsProvider';
}

abstract class _$TemptationAnalytics
    extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as AnalyticsTimeRange?;
  AnalyticsTimeRange? get range => _$args;

  FutureOr<Map<String, dynamic>> build({AnalyticsTimeRange? range});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(range: _$args);
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

/// Provider for all XP analytics data
@ProviderFor(XPAnalytics)
const xPAnalyticsProvider = XPAnalyticsFamily._();

/// Provider for all XP analytics data
final class XPAnalyticsProvider
    extends $AsyncNotifierProvider<XPAnalytics, Map<String, dynamic>> {
  /// Provider for all XP analytics data
  const XPAnalyticsProvider._({
    required XPAnalyticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'xPAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$xPAnalyticsHash();

  @override
  String toString() {
    return r'xPAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  XPAnalytics create() => XPAnalytics();

  @override
  bool operator ==(Object other) {
    return other is XPAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$xPAnalyticsHash() => r'375d93a78258e35488a31c92f3ef3f69824830a1';

/// Provider for all XP analytics data
final class XPAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
          XPAnalytics,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          AnalyticsTimeRange?
        > {
  const XPAnalyticsFamily._()
    : super(
        retry: null,
        name: r'xPAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for all XP analytics data
  XPAnalyticsProvider call({AnalyticsTimeRange? range}) =>
      XPAnalyticsProvider._(argument: range, from: this);

  @override
  String toString() => r'xPAnalyticsProvider';
}

abstract class _$XPAnalytics extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as AnalyticsTimeRange?;
  AnalyticsTimeRange? get range => _$args;

  FutureOr<Map<String, dynamic>> build({AnalyticsTimeRange? range});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(range: _$args);
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

/// Provider for all analytics data combined
@ProviderFor(AllAnalytics)
const allAnalyticsProvider = AllAnalyticsFamily._();

/// Provider for all analytics data combined
final class AllAnalyticsProvider
    extends $AsyncNotifierProvider<AllAnalytics, Map<String, dynamic>> {
  /// Provider for all analytics data combined
  const AllAnalyticsProvider._({
    required AllAnalyticsFamily super.from,
    required AnalyticsTimeRange? super.argument,
  }) : super(
         retry: null,
         name: r'allAnalyticsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$allAnalyticsHash();

  @override
  String toString() {
    return r'allAnalyticsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AllAnalytics create() => AllAnalytics();

  @override
  bool operator ==(Object other) {
    return other is AllAnalyticsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$allAnalyticsHash() => r'969ee5da2ec95ffbe26532aecd0236e58f3f0909';

/// Provider for all analytics data combined
final class AllAnalyticsFamily extends $Family
    with
        $ClassFamilyOverride<
          AllAnalytics,
          AsyncValue<Map<String, dynamic>>,
          Map<String, dynamic>,
          FutureOr<Map<String, dynamic>>,
          AnalyticsTimeRange?
        > {
  const AllAnalyticsFamily._()
    : super(
        retry: null,
        name: r'allAnalyticsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider for all analytics data combined
  AllAnalyticsProvider call({AnalyticsTimeRange? range}) =>
      AllAnalyticsProvider._(argument: range, from: this);

  @override
  String toString() => r'allAnalyticsProvider';
}

abstract class _$AllAnalytics extends $AsyncNotifier<Map<String, dynamic>> {
  late final _$args = ref.$arg as AnalyticsTimeRange?;
  AnalyticsTimeRange? get range => _$args;

  FutureOr<Map<String, dynamic>> build({AnalyticsTimeRange? range});
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(range: _$args);
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
