import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escape/models/streak_model.dart';
import 'package:escape/models/prayer_model.dart';
import 'package:escape/models/temptation_model.dart';
import 'package:escape/repositories/streak_repository.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/repositories/temptation_repository.dart';

part 'history_providers.g.dart';

// Streak History Provider
@riverpod
class StreakHistory extends _$StreakHistory {
  @override
  Future<List<Streak>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final repository = ref.read(streakRepositoryProvider.notifier);
    return await repository.getStreaksWithPagination(
      limit: limit,
      startDate: startDate,
      endDate: endDate,
    );
  }

  /// Refresh the streak history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter streaks by success status
  Future<List<Streak>> filterBySuccess(bool isSuccess) async {
    final streaks = await future;
    return streaks.where((streak) => streak.isSuccess == isSuccess).toList();
  }

  /// Search streaks by query
  Future<List<Streak>> search(String query) async {
    if (query.isEmpty) return await future;

    final repository = ref.read(streakRepositoryProvider.notifier);
    return await repository.searchStreaks();
  }
}

// Prayer History Provider
@riverpod
class PrayerHistory extends _$PrayerHistory {
  @override
  Future<List<Prayer>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    String? prayerName,
    bool? isCompleted,
  }) async {
    final repository = ref.read(prayerRepositoryProvider.notifier);
    return await repository.getPrayersWithPagination(
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      prayerName: prayerName,
      isCompleted: isCompleted,
    );
  }

  /// Refresh the prayer history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter prayers by completion status
  Future<List<Prayer>> filterByCompletion(bool isCompleted) async {
    final prayers = await future;
    return prayers
        .where((prayer) => prayer.isCompleted == isCompleted)
        .toList();
  }

  /// Filter prayers by name
  Future<List<Prayer>> filterByName(String prayerName) async {
    final prayers = await future;
    return prayers.where((prayer) => prayer.name == prayerName).toList();
  }

  /// Search prayers by query
  Future<List<Prayer>> search(String query) async {
    if (query.isEmpty) return await future;

    final repository = ref.read(prayerRepositoryProvider.notifier);
    return await repository.searchPrayers();
  }
}

// Temptation History Provider
@riverpod
class TemptationHistory extends _$TemptationHistory {
  @override
  Future<List<Temptation>> build({
    int limit = 100,
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
  }) async {
    final repository = ref.read(temptationRepositoryProvider.notifier);
    return await repository.getTemptationsWithPagination(
      limit: limit,
      startDate: startDate,
      endDate: endDate,
      wasSuccessful: wasSuccessful,
      isResolved: isResolved,
    );
  }

  /// Refresh the temptation history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter temptations by success status
  Future<List<Temptation>> filterBySuccess(bool wasSuccessful) async {
    final temptations = await future;
    return temptations.where((t) => t.wasSuccessful == wasSuccessful).toList();
  }

  /// Filter temptations by triggers
  Future<List<Temptation>> filterByTriggers(List<String> triggers) async {
    final temptations = await future;
    return temptations
        .where((t) => t.triggers.any((trigger) => triggers.contains(trigger)))
        .toList();
  }

  /// Search temptations by query
  Future<List<Temptation>> search(String query) async {
    if (query.isEmpty) return await future;

    final repository = ref.read(temptationRepositoryProvider.notifier);
    return await repository.searchTemptations();
  }
}
