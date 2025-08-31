import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/challenge_model.dart';
import 'challenges_repository_provider.dart';

part 'challenges_provider.g.dart';

/// A provider that manages challenges by combining hardcoded challenges with database challenges
/// This provider watches for challenges from the database and merges them with hardcoded challenges
@Riverpod(keepAlive: true)
class Challenges extends _$Challenges {
  @override
  Stream<List<Challenge>> build() async* {
    // Get hardcoded challenges
    final hardcodedChallenges = _getHardcodedChallenges();

    // Watch challenges from database
    final challengesRepository = ref.read(
      challengesRepositoryProvider.notifier,
    );
    Stream<List<Challenge>> dbChallengesStream = challengesRepository
        .watchAllChallenges();

    await for (final dbChallenges in dbChallengesStream) {
      // Merge them: replace hardcoded challenges with database ones if they exist
      yield _mergeChallenges(hardcodedChallenges, dbChallenges);
    }
  }

  /// Get hardcoded challenges (these serve as defaults)
  List<Challenge> _getHardcodedChallenges() {
    return [
      // Beginner Challenges (Easy, 10-50 XP)
      Challenge(
        title: 'First Temptation',
        description: 'Record your first temptation in the database',
        featureName: 'temptation',
        conditionJson: '{"field": "count", "operator": ">=", "value": 1}',
        iconPath: 'assets/icons/temptation.png',
        xp: 10,
      ),
      Challenge(
        title: 'One Day Streak',
        description: 'Maintain a 1-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 1}',
        iconPath: 'assets/icons/streak.png',
        xp: 15,
      ),
      Challenge(
        title: 'Morning Reflection',
        description: 'Complete morning reflection for 3 consecutive days',
        featureName: 'prayer',
        conditionJson:
            '{"field": "morning_reflection", "operator": ">=", "value": 3}',
        iconPath: 'assets/icons/prayer.png',
        xp: 20,
      ),
      Challenge(
        title: 'First Success',
        description: 'Successfully overcome your first temptation',
        featureName: 'temptation',
        conditionJson:
            '{"field": "success_count", "operator": ">=", "value": 1}',
        iconPath: 'assets/icons/success.png',
        xp: 25,
      ),
      Challenge(
        title: 'Three Day Warrior',
        description: 'Maintain a 3-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 3}',
        iconPath: 'assets/icons/warrior.png',
        xp: 30,
      ),

      // Intermediate Challenges (Medium, 50-100 XP)
      Challenge(
        title: 'Week Warrior',
        description: 'Maintain a 7-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 7}',
        iconPath: 'assets/icons/week_warrior.png',
        xp: 50,
      ),
      Challenge(
        title: 'Tahajjud Beginner',
        description: 'Complete 1 Tahajjud prayer',
        featureName: 'prayer',
        conditionJson:
            '{"field": "tahajjud_count", "operator": "==", "value": 1}',
        iconPath: 'assets/icons/tahajjud.png',
        xp: 40,
      ),
      Challenge(
        title: 'Prayer Master',
        description: 'Complete all 5 daily prayers for a week',
        featureName: 'prayer',
        conditionJson:
            '{"field": "daily_prayers_completed", "operator": ">=", "value": 35}',
        iconPath: 'assets/icons/prayer_master.png',
        xp: 60,
      ),
      Challenge(
        title: 'Temptation Fighter',
        description: 'Successfully overcome 5 temptations',
        featureName: 'temptation',
        conditionJson:
            '{"field": "success_count", "operator": ">=", "value": 5}',
        iconPath: 'assets/icons/fighter.png',
        xp: 70,
      ),
      Challenge(
        title: 'Gratitude Journal',
        description: 'Write gratitude journal for 7 days straight',
        featureName: 'prayer',
        conditionJson:
            '{"field": "gratitude_entries", "operator": ">=", "value": 7}',
        iconPath: 'assets/icons/gratitude.png',
        xp: 75,
      ),
      Challenge(
        title: 'Two Week Champion',
        description: 'Maintain a 14-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 14}',
        iconPath: 'assets/icons/champion.png',
        xp: 80,
      ),

      // Advanced Challenges (Hard, 100-200 XP)
      Challenge(
        title: 'Month Master',
        description: 'Maintain a 30-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 30}',
        iconPath: 'assets/icons/month_master.png',
        xp: 100,
      ),
      Challenge(
        title: 'Prayer Saint',
        description: 'Complete all prayers for a month',
        featureName: 'prayer',
        conditionJson:
            '{"field": "monthly_prayers_completed", "operator": ">=", "value": 150}',
        iconPath: 'assets/icons/saint.png',
        xp: 120,
      ),
      Challenge(
        title: 'Temptation Conqueror',
        description: 'Successfully overcome 20 temptations',
        featureName: 'temptation',
        conditionJson:
            '{"field": "success_count", "operator": ">=", "value": 20}',
        iconPath: 'assets/icons/conqueror.png',
        xp: 150,
      ),
      Challenge(
        title: 'Three Month Legend',
        description: 'Maintain a 90-day streak',
        featureName: 'streak',
        conditionJson: '{"field": "count", "operator": ">=", "value": 90}',
        iconPath: 'assets/icons/legend.png',
        xp: 180,
      ),
      Challenge(
        title: 'Complete Transformation',
        description:
            'Successfully overcome 50 temptations and maintain 60-day streak',
        featureName: 'temptation',
        conditionJson:
            '{"operator": "AND", "conditions": [{"field": "success_count", "operator": ">=", "value": 50}, {"field": "streak_count", "operator": ">=", "value": 60}]}',
        iconPath: 'assets/icons/transformation.png',
        xp: 200,
      ),
    ];
  }

  /// Merge hardcoded challenges with database challenges
  /// Database challenges replace hardcoded ones with the same ID
  List<Challenge> _mergeChallenges(
    List<Challenge> hardcoded,
    List<Challenge> dbChallenges,
  ) {
    final merged = <Challenge>[];

    // Create a map of database challenges by ID for quick lookup
    final dbChallengesMap = {
      for (final challenge in dbChallenges) challenge.title: challenge,
    };

    // Add hardcoded challenges, replacing with database ones if they exist
    for (final hardcodedChallenge in hardcoded) {
      final dbChallenge = dbChallengesMap[hardcodedChallenge.title];
      if (dbChallenge != null) {
        merged.add(dbChallenge);
      } else {
        merged.add(hardcodedChallenge);
      }
    }

    // Add any database challenges that don't exist in hardcoded list
    for (final dbChallenge in dbChallenges) {
      if (!hardcoded.any((c) => c.id == dbChallenge.id)) {
        merged.add(dbChallenge);
      }
    }

    return merged;
  }

  /// Refresh challenges by refetching from database
  Future<void> refresh() async {
    // This will trigger a new stream event
    // The stream will automatically re-emit with updated data
  }
}
