// import 'dart:convert';

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
      default:
        return Icons.star;
    }
  }

  String _getDifficultyText(int xp) {
    if (xp <= 50) return 'Easy';
    if (xp <= 100) return 'Medium';
    return 'Hard';
  }

  // String _formatCondition(String conditionJson) {
  //   try {
  //     final condition = jsonDecode(conditionJson);
  //     if (condition is Map<String, dynamic>) {
  //       if (condition.containsKey('operator')) {
  //         final operator = condition['operator'];
  //         final conditions = condition['conditions'] as List;
  //         return '$operator: ${conditions.length} condition${conditions.length != 1 ? 's' : ''}';
  //       } else {
  //         return '${condition['field']} ${condition['operator']} ${condition['value']}';
  //       }
  //     }
  //   } catch (e) {
  //     return conditionJson;
  //   }
  //   return conditionJson;
  // }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      body: challengesAsync.when(
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

              const SizedBox(height: 16),

              // Challenges Grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth > 600
                          ? 3
                          : constraints.maxWidth > 360
                          ? 2
                          : 1;
                      final childAspectRatio = constraints.maxWidth > 600
                          ? 1.2
                          : 1.0;

                      return GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          childAspectRatio: childAspectRatio,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: challenges.length,
                        itemBuilder: (context, index) {
                          final challenge = challenges[index];
                          return ChallengeCard(
                            title: challenge.title,
                            description: challenge.description,
                            progress: challenge.isCompleted ? 1.0 : 0.0,
                            rating: 4.5,
                            difficulty: _getDifficultyText(challenge.xp),
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
                                _getFeatureIcon(challenge.featureName),
                                color: Theme.of(context).colorScheme.primary,
                                size: 24,
                              ),
                            ),
                            trailingWidgets: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .secondaryContainer
                                      .withValues(alpha: 0.3),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.star,
                                      size: 16,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.secondary,
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${challenge.xp}',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall
                                          ?.copyWith(
                                            color: Theme.of(
                                              context,
                                            ).colorScheme.secondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
