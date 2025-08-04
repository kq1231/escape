import 'dart:async';

import 'package:escape/models/user_profile_model.dart' as user_profile;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/user_profile_repository.dart';

part 'user_profile_provider.g.dart';

/// A provider that handles user profile operations
/// This provider has keepAlive: true since there's only one user profile
@Riverpod(keepAlive: true)
class UserProfile extends _$UserProfile {
  @override
  Future<user_profile.UserProfile?> build() async {
    // Watch the user profile repository for changes
    final repository = ref.read(userProfileRepositoryProvider.notifier);
    Stream stream = repository.watchUserProfile();

    // First await the first event
    user_profile.UserProfile? profile = await stream.first;

    // Then listen to future events
    stream = repository.watchUserProfile(); // Because stream.first
    //consumes the stream (i.e. cancels it)

    StreamSubscription listener = stream.listen((profile) {
      state = AsyncValue.data(profile);
    });

    ref.onDispose(() {
      listener.cancel();
    });

    return profile;
  }

  /// Save the user profile
  Future<int> saveProfile(user_profile.UserProfile profile) async {
    return await ref
        .read(userProfileRepositoryProvider.notifier)
        .saveUserProfile(profile);
  }

  /// Delete the user profile
  Future<bool> deleteProfile() async {
    return await ref
        .read(userProfileRepositoryProvider.notifier)
        .deleteUserProfile();
  }
}
