// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'prayer_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles all prayer-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@ProviderFor(TodaysPrayers)
const todaysPrayersProvider = TodaysPrayersFamily._();

/// A provider that handles all prayer-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
final class TodaysPrayersProvider
    extends $StreamNotifierProvider<TodaysPrayers, List<Prayer>> {
  /// A provider that handles all prayer-related operations
  /// This provider has keepAlive: false (autoDispose) for efficiency
  const TodaysPrayersProvider._({
    required TodaysPrayersFamily super.from,
    required DateTime? super.argument,
  }) : super(
         retry: null,
         name: r'todaysPrayersProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$todaysPrayersHash();

  @override
  String toString() {
    return r'todaysPrayersProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  TodaysPrayers create() => TodaysPrayers();

  @override
  bool operator ==(Object other) {
    return other is TodaysPrayersProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$todaysPrayersHash() => r'3db2c089f8363ca9f2846fe5ff8127709437fdb0';

/// A provider that handles all prayer-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
final class TodaysPrayersFamily extends $Family
    with
        $ClassFamilyOverride<
          TodaysPrayers,
          AsyncValue<List<Prayer>>,
          List<Prayer>,
          Stream<List<Prayer>>,
          DateTime?
        > {
  const TodaysPrayersFamily._()
    : super(
        retry: null,
        name: r'todaysPrayersProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// A provider that handles all prayer-related operations
  /// This provider has keepAlive: false (autoDispose) for efficiency
  TodaysPrayersProvider call([DateTime? date]) =>
      TodaysPrayersProvider._(argument: date, from: this);

  @override
  String toString() => r'todaysPrayersProvider';
}

abstract class _$TodaysPrayers extends $StreamNotifier<List<Prayer>> {
  late final _$args = ref.$arg as DateTime?;
  DateTime? get date => _$args;

  Stream<List<Prayer>> build([DateTime? date]);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
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

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
