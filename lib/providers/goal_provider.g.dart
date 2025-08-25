// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'goal_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles the user's streak goal
/// This provider watches the user profile provider to get and update the streak goal
@ProviderFor(Goal)
const goalProvider = GoalProvider._();

/// A provider that handles the user's streak goal
/// This provider watches the user profile provider to get and update the streak goal
final class GoalProvider extends $NotifierProvider<Goal, int> {
  /// A provider that handles the user's streak goal
  /// This provider watches the user profile provider to get and update the streak goal
  const GoalProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'goalProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$goalHash();

  @$internal
  @override
  Goal create() => Goal();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$goalHash() => r'90ec168710a66f0ac80b885db3c5896273357d1e';

abstract class _$Goal extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
