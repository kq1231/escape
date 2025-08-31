import 'dart:async';
import 'package:escape/providers/challenges_repository_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../models/challenge_model.dart';
import 'challenges_provider.dart';
import 'xp_controller.dart';

part 'challenges_watcher_provider.g.dart';

@Riverpod()
class ChallengesWatcher extends _$ChallengesWatcher {
  @override
  Stream<List<Challenge>> build() {
    final repo = ref.read(challengesRepositoryProvider.notifier);

    return _watchChallenges(repo);
  }

  Stream<List<Challenge>> _watchChallenges(ChallengesRepository repo) async* {
    final streakStream = repo.watchStreakData();
    final prayerStream = repo.watchPrayerData();
    final temptationStream = repo.watchTemptationData();

    // Create a controller to manage the combined output
    final controller = StreamController<List<Challenge>>();

    void checkAndEmitAchievements() async {
      // Get current unmet challenges
      final allChallenges = await ref.read(challengesProvider.future);
      final unmetChallenges = allChallenges
          .where((c) => !c.isCompleted)
          .toList();

      // Check which challenges are newly met
      List<Challenge> newlyAchieved = [];

      for (final challenge in unmetChallenges) {
        if (repo.isChallengeMet(challenge)) {
          newlyAchieved.add(challenge);
          // Mark as completed to prevent re-detection
          repo.markChallengeCompleted(challenge.id);

          // Add XP to user profile
          final xpController = ref.read(xPControllerProvider.notifier);
          xpController.createXP(
            challenge.xp,
            'Challenge completed: ${challenge.title}',
          );
        }
      }

      // Emit newly achieved challenges
      if (newlyAchieved.isNotEmpty) {
        controller.add(newlyAchieved);
      }
    }

    // Listen to each stream and update latest values
    final subscriptions = <StreamSubscription>[];

    subscriptions.add(
      streakStream.listen((data) {
        checkAndEmitAchievements();
      }),
    );

    subscriptions.add(
      prayerStream.listen((data) {
        checkAndEmitAchievements();
      }),
    );

    subscriptions.add(
      temptationStream.listen((data) {
        checkAndEmitAchievements();
      }),
    );

    // Yield from the controller's stream
    yield* controller.stream;

    ref.onDispose(() {
      controller.close();
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
    });
  }
}
