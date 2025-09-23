// import 'dart:convert';
import 'package:escape/theme/app_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../molecules/challenge_card.dart';
import '../../../providers/challenges_provider.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen> {
  IconData _getFeatureIcon(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'streak':
        return Icons.trending_up;
      case 'prayer':
        return Icons.self_improvement;
      case 'temptation':
        return Icons.psychology;
      case 'meditation':
        return Icons.mood;
      case 'reading':
        return Icons.book;
      case 'xp':
        return Icons.star;
      default:
        return Icons.star;
    }
  }

  String _getDifficultyText(int xp) {
    if (xp <= 50) return 'Easy';
    if (xp <= 100) return 'Med';
    return 'Hard';
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      body: SafeArea(
        child: challengesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.error_outline, size: 64, color: Colors.red),
                const SizedBox(height: 16),
                Text('Error loading challenges: $error'),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.refresh(challengesProvider),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
          data: (challenges) {
            // Split challenges into XP challenges and regular challenges
            final xpChallenges = challenges
                .where((c) => c.featureName == 'xp')
                .toList();
            final regularChallenges = challenges
                .where((c) => c.featureName != 'xp')
                .toList();

            return Column(
              children: [
                // Header
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
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(16),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Challenges',
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Complete challenges to earn XP rewards',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Theme.of(
                            context,
                          ).colorScheme.onPrimary.withValues(alpha: 0.8),
                        ),
                      ),
                    ],
                  ),
                ),

                // Scrollable content area
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: AppConstants.spacingM),
                        // XP Challenges Section (now part of the scrollable content)
                        if (xpChallenges.isNotEmpty)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            color: Colors.amber.withValues(alpha: 0.1),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: 24,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'XP Milestones',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: Colors.amber.shade700,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),
                                SizedBox(
                                  height: 250,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: xpChallenges.length,
                                    itemBuilder: (context, index) {
                                      final challenge = xpChallenges[index];
                                      return Container(
                                        width: 160,
                                        margin: const EdgeInsets.only(
                                          right: 12,
                                        ),
                                        child: ChallengeCard(
                                          title: challenge.title,
                                          description: challenge.description,
                                          progress: challenge.isCompleted
                                              ? 1.0
                                              : 0.0,
                                          rating: 0.0,
                                          difficulty:
                                              '', // Empty for XP challenges
                                          xp: challenge.xp,
                                          isCompleted: challenge.isCompleted,
                                          leadingWidget: Container(
                                            width: 48,
                                            height: 48,
                                            decoration: BoxDecoration(
                                              color: Colors.amber.withValues(
                                                alpha: 0.2,
                                              ),
                                              shape: BoxShape.circle,
                                            ),
                                            child: Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 24,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),

                        // Regular Challenges Section
                        Container(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Activity Challenges',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  // Use 2x2 grid for smaller screens, 3x3 for larger screens
                                  final maxCrossAxisExtent =
                                      constraints.maxWidth > 600
                                      ? constraints.maxWidth / 3
                                      : constraints.maxWidth / 2;
                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithMaxCrossAxisExtent(
                                          maxCrossAxisExtent:
                                              maxCrossAxisExtent,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 12,
                                          mainAxisExtent: 300,
                                        ),
                                    itemCount: regularChallenges.length,
                                    itemBuilder: (context, index) {
                                      final challenge =
                                          regularChallenges[index];
                                      return ChallengeCard(
                                        title: challenge.title,
                                        description: challenge.description,
                                        progress: challenge.isCompleted
                                            ? 1.0
                                            : 0.0,
                                        rating: 0.0,
                                        difficulty: _getDifficultyText(
                                          challenge.xp,
                                        ),
                                        xp: challenge.xp,
                                        isCompleted: challenge.isCompleted,
                                        leadingWidget: Container(
                                          width: 48,
                                          height: 48,
                                          decoration: BoxDecoration(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primaryContainer
                                                .withValues(alpha: 0.3),
                                            shape: BoxShape.circle,
                                          ),
                                          child: Icon(
                                            _getFeatureIcon(
                                              challenge.featureName,
                                            ),
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.primary,
                                            size: 24,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
