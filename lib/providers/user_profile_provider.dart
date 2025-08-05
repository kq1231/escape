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
    final repository = ref.read(userProfileRepositoryProvider.notifier);

    // Create stream only once
    final stream = repository.watchUserProfile();

    // Use a Completer to handle the first value
    final completer = Completer<user_profile.UserProfile?>();
    bool isFirst = true;

    StreamSubscription subscription = stream.listen(
      (profile) {
        if (isFirst) {
          // Complete initialization with first value
          completer.complete(profile);
          isFirst = false;
        } else {
          // Handle subsequent updates
          state = AsyncValue.data(profile);
        }
      },
      onError: (error, stackTrace) {
        if (isFirst) {
          completer.completeError(error, stackTrace);
        } else {
          state = AsyncValue.error(error, stackTrace);
        }
      },
    );

    ref.onDispose(() {
      subscription.cancel();
    });

    // Wait for first emission
    return await completer.future;
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
