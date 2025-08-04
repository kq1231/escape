// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

/// A provider that handles user profile operations
/// This provider has keepAlive: true since there's only one user profile
@ProviderFor(UserProfile)
const userProfileProvider = UserProfileProvider._();

/// A provider that handles user profile operations
/// This provider has keepAlive: true since there's only one user profile
final class UserProfileProvider
    extends $AsyncNotifierProvider<UserProfile, user_profile.UserProfile?> {
  /// A provider that handles user profile operations
  /// This provider has keepAlive: true since there's only one user profile
  const UserProfileProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'userProfileProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$userProfileHash();

  @$internal
  @override
  UserProfile create() => UserProfile();
}

String _$userProfileHash() => r'a6d4c1f2be51843f107aba785708fb5c35680267';

abstract class _$UserProfile extends $AsyncNotifier<user_profile.UserProfile?> {
  FutureOr<user_profile.UserProfile?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<user_profile.UserProfile?>,
              user_profile.UserProfile?
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<user_profile.UserProfile?>,
                user_profile.UserProfile?
              >,
              AsyncValue<user_profile.UserProfile?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
