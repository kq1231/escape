// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

@ProviderFor(StreakHistory)
const streakHistoryProvider = StreakHistoryFamily._();

final class StreakHistoryProvider
    extends $AsyncNotifierProvider<StreakHistory, List<Streak>> {
  const StreakHistoryProvider._({
    required StreakHistoryFamily super.from,
    required ({int limit, DateTime? startDate, DateTime? endDate})
    super.argument,
  }) : super(
         retry: null,
         name: r'streakHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$streakHistoryHash();

  @override
  String toString() {
    return r'streakHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  StreakHistory create() => StreakHistory();

  @override
  bool operator ==(Object other) {
    return other is StreakHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$streakHistoryHash() => r'52e02f65c9ea23ae5667096599f5c583a94b152e';

final class StreakHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          StreakHistory,
          AsyncValue<List<Streak>>,
          List<Streak>,
          FutureOr<List<Streak>>,
          ({int limit, DateTime? startDate, DateTime? endDate})
        > {
  const StreakHistoryFamily._()
    : super(
        retry: null,
        name: r'streakHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  StreakHistoryProvider call({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
  }) => StreakHistoryProvider._(
    argument: (limit: limit, startDate: startDate, endDate: endDate),
    from: this,
  );

  @override
  String toString() => r'streakHistoryProvider';
}

abstract class _$StreakHistory extends $AsyncNotifier<List<Streak>> {
  late final _$args =
      ref.$arg as ({int limit, DateTime? startDate, DateTime? endDate});
  int get limit => _$args.limit;
  DateTime? get startDate => _$args.startDate;
  DateTime? get endDate => _$args.endDate;

  FutureOr<List<Streak>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      limit: _$args.limit,
      startDate: _$args.startDate,
      endDate: _$args.endDate,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Streak>>, List<Streak>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Streak>>, List<Streak>>,
              AsyncValue<List<Streak>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(PrayerHistory)
const prayerHistoryProvider = PrayerHistoryFamily._();

final class PrayerHistoryProvider
    extends $AsyncNotifierProvider<PrayerHistory, List<Prayer>> {
  const PrayerHistoryProvider._({
    required PrayerHistoryFamily super.from,
    required ({
      int limit,
      DateTime? startDate,
      DateTime? endDate,
      String? prayerName,
      bool? isCompleted,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'prayerHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$prayerHistoryHash();

  @override
  String toString() {
    return r'prayerHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  PrayerHistory create() => PrayerHistory();

  @override
  bool operator ==(Object other) {
    return other is PrayerHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$prayerHistoryHash() => r'9659e2a9bacec6339ff298969a796b0b3a0d2104';

final class PrayerHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          PrayerHistory,
          AsyncValue<List<Prayer>>,
          List<Prayer>,
          FutureOr<List<Prayer>>,
          ({
            int limit,
            DateTime? startDate,
            DateTime? endDate,
            String? prayerName,
            bool? isCompleted,
          })
        > {
  const PrayerHistoryFamily._()
    : super(
        retry: null,
        name: r'prayerHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  PrayerHistoryProvider call({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    String? prayerName,
    bool? isCompleted,
  }) => PrayerHistoryProvider._(
    argument: (
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      prayerName: prayerName,
      isCompleted: isCompleted,
    ),
    from: this,
  );

  @override
  String toString() => r'prayerHistoryProvider';
}

abstract class _$PrayerHistory extends $AsyncNotifier<List<Prayer>> {
  late final _$args =
      ref.$arg
          as ({
            int limit,
            DateTime? startDate,
            DateTime? endDate,
            String? prayerName,
            bool? isCompleted,
          });
  int get limit => _$args.limit;
  DateTime? get startDate => _$args.startDate;
  DateTime? get endDate => _$args.endDate;
  String? get prayerName => _$args.prayerName;
  bool? get isCompleted => _$args.isCompleted;

  FutureOr<List<Prayer>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    String? prayerName,
    bool? isCompleted,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      limit: _$args.limit,
      startDate: _$args.startDate,
      endDate: _$args.endDate,
      prayerName: _$args.prayerName,
      isCompleted: _$args.isCompleted,
    );
    final ref = this.ref as $Ref<AsyncValue<List<Prayer>>, List<Prayer>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Prayer>>, List<Prayer>>,
              AsyncValue<List<Prayer>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(TemptationHistory)
const temptationHistoryProvider = TemptationHistoryFamily._();

final class TemptationHistoryProvider
    extends $AsyncNotifierProvider<TemptationHistory, List<Temptation>> {
  const TemptationHistoryProvider._({
    required TemptationHistoryFamily super.from,
    required ({
      int limit,
      DateTime? startDate,
      DateTime? endDate,
      bool? wasSuccessful,
      bool? isResolved,
    })
    super.argument,
  }) : super(
         retry: null,
         name: r'temptationHistoryProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$temptationHistoryHash();

  @override
  String toString() {
    return r'temptationHistoryProvider'
        ''
        '$argument';
  }

  @$internal
  @override
  TemptationHistory create() => TemptationHistory();

  @override
  bool operator ==(Object other) {
    return other is TemptationHistoryProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$temptationHistoryHash() => r'ac057a3d8ab8e87c610832c67d55e2eadee562fe';

final class TemptationHistoryFamily extends $Family
    with
        $ClassFamilyOverride<
          TemptationHistory,
          AsyncValue<List<Temptation>>,
          List<Temptation>,
          FutureOr<List<Temptation>>,
          ({
            int limit,
            DateTime? startDate,
            DateTime? endDate,
            bool? wasSuccessful,
            bool? isResolved,
          })
        > {
  const TemptationHistoryFamily._()
    : super(
        retry: null,
        name: r'temptationHistoryProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  TemptationHistoryProvider call({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
  }) => TemptationHistoryProvider._(
    argument: (
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      wasSuccessful: wasSuccessful,
      isResolved: isResolved,
    ),
    from: this,
  );

  @override
  String toString() => r'temptationHistoryProvider';
}

abstract class _$TemptationHistory extends $AsyncNotifier<List<Temptation>> {
  late final _$args =
      ref.$arg
          as ({
            int limit,
            DateTime? startDate,
            DateTime? endDate,
            bool? wasSuccessful,
            bool? isResolved,
          });
  int get limit => _$args.limit;
  DateTime? get startDate => _$args.startDate;
  DateTime? get endDate => _$args.endDate;
  bool? get wasSuccessful => _$args.wasSuccessful;
  bool? get isResolved => _$args.isResolved;

  FutureOr<List<Temptation>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
  });
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(
      limit: _$args.limit,
      startDate: _$args.startDate,
      endDate: _$args.endDate,
      wasSuccessful: _$args.wasSuccessful,
      isResolved: _$args.isResolved,
    );
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
