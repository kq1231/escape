import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'user_profile_provider.dart';

part 'goal_provider.g.dart';

/// A provider that handles the user's streak goal
/// This provider watches the user profile provider to get and update the streak goal
@Riverpod(keepAlive: true)
class Goal extends _$Goal {
  @override
  int build() {
    // Watch the user profile provider for changes
    final userProfile = ref.watch(userProfileProvider);

    // Return the streak goal from the user profile, or 1 as default
    return userProfile.requireValue!.streakGoal;
  }

  /// Update the streak goal in the user profile
  Future<void> updateGoal(int newGoal) async {
    // Get the current user profile
    final userProfile = ref.read(userProfileProvider);

    // Check if we have a user profile
    if (userProfile.value != null) {
      // Create an updated user profile with the new goal
      final updatedProfile = userProfile.value!.copyWith(
        streakGoal: newGoal,
        lastUpdated: DateTime.now(),
      );

      // Save the updated profile using the user profile provider's save method
      await ref.read(userProfileProvider.notifier).saveProfile(updatedProfile);
    }
  }
}
