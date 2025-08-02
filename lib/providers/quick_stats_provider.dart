import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escape/models/quick_stats_model.dart' as quick_stats;
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/repositories/streak_repository.dart';
import 'package:escape/models/streak_model.dart';

part 'quick_stats_provider.g.dart';

@Riverpod(keepAlive: false)
class QuickStats extends _$QuickStats {
  @override
  Stream<quick_stats.QuickStats> build() {
    final prayerRepository = ref.read(prayerRepositoryProvider.notifier);
    final streakRepository = ref.read(streakRepositoryProvider.notifier);

    return _watchQuickStats(prayerRepository, streakRepository);
  }

  Stream<quick_stats.QuickStats> _watchQuickStats(
    PrayerRepository prayerRepository,
    StreakRepository streakRepository,
  ) async* {
    final prayerCountStream = prayerRepository.watchCompletedPrayerCount();
    final bestStreakStream = streakRepository.watchBestStreak();
    final currentStreakStream = streakRepository.watchCurrentStreak();

    // Get initial values
    int? latestPrayerCount;
    Streak? latestBestStreak;
    Streak? latestCurrentStreak;

    // Create a controller to manage the combined output
    final controller = StreamController<quick_stats.QuickStats>();

    void emitStats() {
      if (latestPrayerCount != null) {
        controller.add(
          quick_stats.QuickStats(
            totalPrayers: latestPrayerCount!,
            bestStreak: latestBestStreak?.count ?? 0,
            currentMood: latestCurrentStreak?.moodIntensity ?? 5,
            progressToGoal: latestCurrentStreak != null
                ? (latestCurrentStreak!.goal > 0
                      ? (latestCurrentStreak!.count /
                                latestCurrentStreak!.goal *
                                100)
                            .round()
                      : 0)
                : 0,
          ),
        );
      }
    }

    // Listen to each stream and update latest values
    final subscriptions = <StreamSubscription>[];

    subscriptions.add(
      prayerCountStream.listen((count) {
        latestPrayerCount = count;
        emitStats();
      }),
    );

    subscriptions.add(
      bestStreakStream.listen((streak) {
        latestBestStreak = streak;
        emitStats();
      }),
    );

    subscriptions.add(
      currentStreakStream.listen((streak) {
        latestCurrentStreak = streak;
        emitStats();
      }),
    );

    // Yield from the controller's stream
    yield* controller.stream;

    ref.onDispose(() {
      controller.close();
      for (final subscription in subscriptions) {
        subscription.cancel();
      }
      print("DISPOSED");
    });
  }
}
