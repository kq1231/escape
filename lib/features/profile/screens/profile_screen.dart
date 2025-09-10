import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/user_profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  // XP thresholds and corresponding titles
  static const Map<int, String> _xpTitles = {
    0: 'Beginner',
    1400: 'Novice',
    4200: 'Warrior', // 3 days worth of XP
    7000: 'Champion', // 5 days worth of XP
    9800: 'Master', // 7 days worth of XP
    42000: 'Legend', // 30 days worth of XP
    126000: 'Hero', // 90 days worth of XP
    365000: 'Grandmaster', // 1 year worth of XP
    1000000: 'Awesome', // Long-term achievement
  };

  // Get user title based on XP
  static String _getUserTitle(int xp) {
    String title = 'Beginner';
    for (final threshold in _xpTitles.keys.toList()..sort()) {
      if (xp >= threshold) {
        title = _xpTitles[threshold]!;
      } else {
        break;
      }
    }
    return title;
  }

  // Get next XP threshold
  static int? _getNextThreshold(int xp) {
    final thresholds = _xpTitles.keys.toList()..sort();
    for (final threshold in thresholds) {
      if (threshold > xp) {
        return threshold;
      }
    }
    return null; // Max level reached
  }

  // Get progress to next level (0.0 to 1.0)
  static double _getProgressToNext(int xp) {
    final currentThreshold = _xpTitles.keys
        .where((key) => key <= xp)
        .reduce((max, key) => key > max ? key : max);

    final nextThreshold = _getNextThreshold(xp);
    if (nextThreshold == null) return 1.0; // Max level

    final range = nextThreshold - currentThreshold;
    final progress = xp - currentThreshold;

    return progress / range;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Profile',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        centerTitle: true,
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text(
            'Error: $error',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        data: (profile) {
          if (profile == null) {
            return const Center(child: Text('No profile found'));
          }

          final userTitle = _getUserTitle(profile.xp);
          final nextThreshold = _getNextThreshold(profile.xp);
          final progress = _getProgressToNext(profile.xp);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile Picture and XP Section
                Center(
                  child: Column(
                    children: [
                      // Profile Picture
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profile.profilePicture.isNotEmpty
                            ? AssetImage(profile.profilePicture)
                            : null,
                        child: profile.profilePicture.isEmpty
                            ? const Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.grey,
                              )
                            : null,
                      ),
                      const SizedBox(height: 16),

                      // XP and Title Section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Theme.of(context).colorScheme.primary,
                              Theme.of(context).colorScheme.primaryContainer,
                            ],
                          ),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // XP Amount
                            Text(
                              '${profile.xp} XP',
                              style: Theme.of(context).textTheme.headlineMedium
                                  ?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 2.0,
                                  ),
                            ),

                            const SizedBox(height: 8),

                            // User Title
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                  color: Colors.amber,
                                  width: 1.5,
                                ),
                              ),
                              child: Text(
                                userTitle,
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      color: Colors.amber,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Progress Bar
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: progress,
                                  minHeight: 10,
                                  backgroundColor: Colors.white.withValues(
                                    alpha: 0.3,
                                  ),
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.amber,
                                  ),
                                  borderRadius: BorderRadius.circular(5),
                                ),

                                const SizedBox(height: 8),

                                // Progress Text
                                if (nextThreshold != null)
                                  Text(
                                    '${nextThreshold - profile.xp} XP to next rank',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withValues(alpha: 0.8),
                                        ),
                                  )
                                else
                                  Text(
                                    'Maximum rank achieved!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .onPrimary
                                              .withValues(alpha: 0.8),
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // Name
                Text(
                  'Name',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  profile.name.isEmpty ? 'Not set' : profile.name,
                  style: Theme.of(context).textTheme.titleLarge,
                ),

                const SizedBox(height: 32),

                // Goals
                Text(
                  'Goals',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (profile.goals.isEmpty)
                  Text(
                    'No goals added yet',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.goals
                        .map(
                          (goal) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.blue.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              goal,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 32),

                // Hobbies
                Text(
                  'Hobbies',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (profile.hobbies.isEmpty)
                  Text(
                    'No hobbies added yet',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.hobbies
                        .map(
                          (hobby) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.green.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              hobby,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                const SizedBox(height: 32),

                // Triggers
                Text(
                  'Triggers',
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                if (profile.triggers.isEmpty)
                  Text(
                    'No triggers added yet',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey),
                  )
                else
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: profile.triggers
                        .map(
                          (trigger) => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: Colors.red.withValues(alpha: 0.3),
                              ),
                            ),
                            child: Text(
                              trigger,
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.red.shade700),
                            ),
                          ),
                        )
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
