import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/user_profile_model.dart';

part 'user_profile_repository.g.dart';

@Riverpod(keepAlive: false)
class UserProfileRepository extends _$UserProfileRepository {
  late Box<UserProfile> _userProfileBox;

  @override
  FutureOr<void> build() async {
    _userProfileBox = ref
        .read(objectboxProvider)
        .requireValue
        .store
        .box<UserProfile>();
  }

  // Get the user profile (always ID 1)
  Future<UserProfile?> getUserProfile() async {
    return await _userProfileBox.getAsync(1);
  }

  // Create or update the user profile
  Future<int> saveUserProfile(UserProfile profile) async {
    // Ensure the ID is always 1 for the single user profile
    final profileWithId = profile.copyWith(id: 1);
    final id = await _userProfileBox.putAsync(profileWithId);

    return id;
  }

  // Check if user profile exists and is complete
  Future<bool> isOnboardingComplete() async {
    final profile = await getUserProfile();
    return profile != null && profile.isComplete;
  }

  // Delete the user profile
  Future<bool> deleteUserProfile() async {
    final result = await _userProfileBox.removeAsync(1);
    return result;
  }

  // Watch for changes to the user profile
  Stream<UserProfile?> watchUserProfile() {
    // Build and watch the query for the user profile with ID 1
    return _userProfileBox
        .query(UserProfile_.id.equals(1))
        .watch(triggerImmediately: true)
        // Map it to a single profile object or null
        .asyncMap((query) async {
          final result = await query.findFirstAsync();
          return result;
        });
  }
}
