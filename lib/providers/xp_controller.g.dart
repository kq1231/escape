// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'xp_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A controller that handles XP-related operations
/// This controller has keepAlive: false (autoDispose) for efficiency
@ProviderFor(XPController)
const xPControllerProvider = XPControllerProvider._();

/// A controller that handles XP-related operations
/// This controller has keepAlive: false (autoDispose) for efficiency
final class XPControllerProvider
    extends $AsyncNotifierProvider<XPController, void> {
  /// A controller that handles XP-related operations
  /// This controller has keepAlive: false (autoDispose) for efficiency
  const XPControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'xPControllerProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$xPControllerHash();

  @$internal
  @override
  XPController create() => XPController();
}

String _$xPControllerHash() => r'3dfc9ae6e0a6a8a55d7be4a113076b193f0c27ee';

abstract class _$XPController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
