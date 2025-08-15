import 'package:escape/models/streak_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../widgets/goal_modal.dart';
import '../../../providers/goal_provider.dart';
import '../../../providers/user_profile_provider.dart';
import '../../profile/screens/profile_screen.dart';
import 'dart:io';

class StreakOrganism extends ConsumerWidget {
  final Streak streak;
  final String labelText;
  final VoidCallback? onTap;
  final bool isActive;

  const StreakOrganism({
    super.key,
    required this.streak,
    this.labelText = 'Days Clean',
    this.onTap,
    this.isActive = true,
  });

  String _getGoalDisplay(int goal) {
    if (goal % 365 == 0) {
      return '${goal ~/ 365}y';
    } else if (goal % 30 == 0) {
      return '${goal ~/ 30}m';
    } else if (goal % 7 == 0) {
      return '${goal ~/ 7}w';
    } else {
      return '$goal';
    }
  }

  Widget _buildGoalButton(BuildContext context, WidgetRef ref) {
    // Get the goal from the goal provider
    final goal = ref.watch(goalProvider);

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppTheme.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: IconButton(
        icon: Text(
          _getGoalDisplay(goal),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (BuildContext context) {
              return const GoalModal();
            },
          );
        },
      ),
    );
  }

  Widget _buildProfileButton(BuildContext context, WidgetRef ref) {
    // Get the user profile from the provider
    final userProfileAsync = ref.watch(userProfileProvider);

    return userProfileAsync.when(
      data: (userProfile) {
        // If no profile, show default user icon
        if (userProfile!.profilePicture.isEmpty) {
          return Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: IconButton(
              icon: const Icon(Icons.person, color: AppTheme.white, size: 24),
              onPressed: () {
                // Navigate to profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
            ),
          );
        }
        // Check if user has a profile picture
        else {
          // Try to load the profile image
          return Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: GestureDetector(
              onTap: () {
                // Navigate to profile screen
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                );
              },
              child: CircleAvatar(
                radius: 16,
                backgroundImage: FileImage(File(userProfile.profilePicture)),
                backgroundColor: AppTheme.white.withValues(alpha: 0.2),
              ),
            ),
          );
        }
      },
      loading: () => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: const IconButton(
          icon: Icon(Icons.person, color: AppTheme.white, size: 24),
          onPressed: null,
        ),
      ),
      error: (error, stack) => Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: AppTheme.white.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(AppTheme.radiusM),
        ),
        child: IconButton(
          icon: const Icon(Icons.person, color: AppTheme.white, size: 24),
          onPressed: () {
            // Navigate to profile screen even if there's an error
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity, // Take full width
        padding: const EdgeInsets.all(AppTheme.spacingL),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppTheme.primaryGreen, AppTheme.lightGreen],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: AppTheme.primaryGreen.withValues(alpha: 0.3),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              children: [
                // Goal setting button at top right
                Positioned(
                  top: 0,
                  right: 0,
                  child: _buildGoalButton(context, ref),
                ),

                if (constraints.maxWidth < 300)
                  Positioned(child: _buildProfileButton(context, ref)),

                // For larger widths, show profile button below goal button
                if (constraints.maxWidth >= 300)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Column(
                      children: [
                        // Hide profile button in original position
                        const SizedBox.shrink(),
                        const SizedBox(height: 56), // Space for goal button
                        // Profile button below goal button
                        _buildProfileButton(context, ref),
                      ],
                    ),
                  ),

                // Main content
                SizedBox(
                  width: double.infinity,
                  child: constraints.maxWidth >= 300
                      ? Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Fire icon with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform:
                                  isActive
                                        ? Matrix4.identity()
                                        : Matrix4.rotationZ(0.1)
                                    ..scale(1.2),
                              child: Icon(
                                Icons.local_fire_department,
                                color: AppTheme.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(width: AppTheme.spacingL),
                            // Text content
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Streak count with larger, more prominent text
                                  Text(
                                    '${streak.count}',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontSize: 60,
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.white,
                                          shadows: [
                                            Shadow(
                                              color: AppTheme.darkGreen
                                                  .withValues(alpha: 0.5),
                                              offset: const Offset(2, 2),
                                              blurRadius: 4,
                                            ),
                                          ],
                                        ),
                                  ),
                                  const SizedBox(height: AppTheme.spacingXS),
                                  // Label with smaller, but still readable text
                                  Text(
                                    labelText,
                                    style: Theme.of(context).textTheme.bodyLarge
                                        ?.copyWith(
                                          color: AppTheme.white,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 18,
                                        ),
                                  ),
                                  const SizedBox(height: AppTheme.spacingXS),
                                ],
                              ),
                            ),
                          ],
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Fire icon with animation
                            AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              transform:
                                  isActive
                                        ? Matrix4.identity()
                                        : Matrix4.rotationZ(0.1)
                                    ..scale(1.2),
                              child: Icon(
                                Icons.local_fire_department,
                                color: AppTheme.white,
                                size: 40,
                              ),
                            ),
                            const SizedBox(height: AppTheme.spacingS),
                            // Streak count with larger, more prominent text
                            Text(
                              '${streak.count}',
                              style: Theme.of(context).textTheme.displayLarge
                                  ?.copyWith(
                                    fontSize: 70,
                                    color: AppTheme.white,
                                    shadows: [
                                      Shadow(
                                        color: AppTheme.darkGreen.withValues(
                                          alpha: 0.5,
                                        ),
                                        offset: const Offset(2, 2),
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                            // Label with smaller, but still readable text
                            Text(
                              labelText,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppTheme.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18,
                                  ),
                            ),
                            const SizedBox(height: AppTheme.spacingXS),
                          ],
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
