import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escape/models/streak_model.dart';
import 'package:escape/models/prayer_model.dart';
import 'package:escape/models/temptation_model.dart';
import 'package:escape/repositories/streak_repository.dart';
import 'package:escape/repositories/prayer_repository.dart';
import 'package:escape/repositories/temptation_repository.dart';

part 'history_providers.g.dart';

// Pagination state classes
class PaginationState<T> {
  final List<T> items;
  final bool isLoading;
  final bool hasMore;
  final int currentOffset;
  final String? error;

  const PaginationState({
    required this.items,
    this.isLoading = false,
    this.hasMore = true,
    this.currentOffset = 0,
    this.error,
  });

  PaginationState<T> copyWith({
    List<T>? items,
    bool? isLoading,
    bool? hasMore,
    int? currentOffset,
    String? error,
  }) {
    return PaginationState<T>(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      hasMore: hasMore ?? this.hasMore,
      currentOffset: currentOffset ?? this.currentOffset,
      error: error ?? this.error,
    );
  }
}

// Streak History Provider (Legacy - keeping for backward compatibility)
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

// Paginated Streak History Provider
@riverpod
class PaginatedStreakHistory extends _$PaginatedStreakHistory {
  static const int _pageSize = 20;

  @override
  Future<PaginationState<Streak>> build({
    DateTime? startDate,
    DateTime? endDate,
    bool? isSuccess,
  }) async {
    final repository = ref.read(streakRepositoryProvider.notifier);

    try {
      final streaks = await repository.getStreaksWithPagination(
        offset: 0,
        limit: _pageSize,
        startDate: startDate,
        endDate: endDate,
        isSuccess: isSuccess,
      );

      return PaginationState<Streak>(
        items: streaks,
        hasMore: streaks.length == _pageSize,
        currentOffset: _pageSize,
      );
    } catch (e) {
      return PaginationState<Streak>(
        items: [],
        error: e.toString(),
        hasMore: false,
      );
    }
  }

  /// Load more streaks (next page)
  Future<void> loadMore() async {
    final currentState = await future;
    if (currentState.isLoading || !currentState.hasMore) return;

    // Update state to show loading
    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final repository = ref.read(streakRepositoryProvider.notifier);
      final newStreaks = await repository.getStreaksWithPagination(
        offset: currentState.currentOffset,
        limit: _pageSize,
        startDate: null, // You might want to store these in state
        endDate: null,
        isSuccess: null,
      );

      final updatedItems = [...currentState.items, ...newStreaks];

      state = AsyncValue.data(
        PaginationState<Streak>(
          items: updatedItems,
          hasMore: newStreaks.length == _pageSize,
          currentOffset: currentState.currentOffset + newStreaks.length,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Refresh the streak history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter streaks by success status
  Future<List<Streak>> filterBySuccess(bool isSuccess) async {
    final currentState = await future;
    return currentState.items
        .where((streak) => streak.isSuccess == isSuccess)
        .toList();
  }

  /// Search streaks by query
  Future<List<Streak>> search(String query) async {
    if (query.isEmpty) {
      final currentState = await future;
      return currentState.items;
    }

    final repository = ref.read(streakRepositoryProvider.notifier);
    return await repository.searchStreaks();
  }
}

// Prayer History Provider (Legacy - keeping for backward compatibility)
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

// Paginated Prayer History Provider
@riverpod
class PaginatedPrayerHistory extends _$PaginatedPrayerHistory {
  static const int _pageSize = 20;

  @override
  Future<PaginationState<Prayer>> build({
    DateTime? startDate,
    DateTime? endDate,
    String? prayerName,
    bool? isCompleted,
  }) async {
    final repository = ref.read(prayerRepositoryProvider.notifier);

    try {
      final prayers = await repository.getPrayersWithPagination(
        offset: 0,
        limit: _pageSize,
        startDate: startDate,
        endDate: endDate,
        prayerName: prayerName,
        isCompleted: isCompleted,
      );

      return PaginationState<Prayer>(
        items: prayers,
        hasMore: prayers.length == _pageSize,
        currentOffset: _pageSize,
      );
    } catch (e) {
      return PaginationState<Prayer>(
        items: [],
        error: e.toString(),
        hasMore: false,
      );
    }
  }

  /// Load more prayers (next page)
  Future<void> loadMore() async {
    final currentState = await future;
    if (currentState.isLoading || !currentState.hasMore) return;

    // Update state to show loading
    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final repository = ref.read(prayerRepositoryProvider.notifier);
      final newPrayers = await repository.getPrayersWithPagination(
        offset: currentState.currentOffset,
        limit: _pageSize,
        startDate: null, // You might want to store these in state
        endDate: null,
        prayerName: null,
        isCompleted: null,
      );

      final updatedItems = [...currentState.items, ...newPrayers];

      state = AsyncValue.data(
        PaginationState<Prayer>(
          items: updatedItems,
          hasMore: newPrayers.length == _pageSize,
          currentOffset: currentState.currentOffset + newPrayers.length,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Refresh the prayer history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter prayers by completion status
  Future<List<Prayer>> filterByCompletion(bool isCompleted) async {
    final currentState = await future;
    return currentState.items
        .where((prayer) => prayer.isCompleted == isCompleted)
        .toList();
  }

  /// Filter prayers by name
  Future<List<Prayer>> filterByName(String prayerName) async {
    final currentState = await future;
    return currentState.items
        .where((prayer) => prayer.name == prayerName)
        .toList();
  }

  /// Search prayers by query
  Future<List<Prayer>> search(String query) async {
    if (query.isEmpty) {
      final currentState = await future;
      return currentState.items;
    }

    final repository = ref.read(prayerRepositoryProvider.notifier);
    return await repository.searchPrayers();
  }
}

// Temptation History Provider (Legacy - keeping for backward compatibility)
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

// Paginated Temptation History Provider
@riverpod
class PaginatedTemptationHistory extends _$PaginatedTemptationHistory {
  static const int _pageSize = 20;

  @override
  Future<PaginationState<Temptation>> build({
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
  }) async {
    final repository = ref.read(temptationRepositoryProvider.notifier);

    try {
      final temptations = await repository.getTemptationsWithPagination(
        offset: 0,
        limit: _pageSize,
        startDate: startDate,
        endDate: endDate,
        wasSuccessful: wasSuccessful,
        isResolved: isResolved,
      );

      return PaginationState<Temptation>(
        items: temptations,
        hasMore: temptations.length == _pageSize,
        currentOffset: _pageSize,
      );
    } catch (e) {
      return PaginationState<Temptation>(
        items: [],
        error: e.toString(),
        hasMore: false,
      );
    }
  }

  /// Load more temptations (next page)
  Future<void> loadMore() async {
    final currentState = await future;
    if (currentState.isLoading || !currentState.hasMore) return;

    // Update state to show loading
    state = AsyncValue.data(currentState.copyWith(isLoading: true));

    try {
      final repository = ref.read(temptationRepositoryProvider.notifier);
      final newTemptations = await repository.getTemptationsWithPagination(
        offset: currentState.currentOffset,
        limit: _pageSize,
        startDate: null, // You might want to store these in state
        endDate: null,
        wasSuccessful: null,
        isResolved: null,
      );

      final updatedItems = [...currentState.items, ...newTemptations];

      state = AsyncValue.data(
        PaginationState<Temptation>(
          items: updatedItems,
          hasMore: newTemptations.length == _pageSize,
          currentOffset: currentState.currentOffset + newTemptations.length,
          isLoading: false,
        ),
      );
    } catch (e) {
      state = AsyncValue.data(
        currentState.copyWith(isLoading: false, error: e.toString()),
      );
    }
  }

  /// Refresh the temptation history
  Future<void> refresh() async {
    ref.invalidateSelf();
  }

  /// Filter temptations by success status
  Future<List<Temptation>> filterBySuccess(bool wasSuccessful) async {
    final currentState = await future;
    return currentState.items
        .where((t) => t.wasSuccessful == wasSuccessful)
        .toList();
  }

  /// Filter temptations by triggers
  Future<List<Temptation>> filterByTriggers(List<String> triggers) async {
    final currentState = await future;
    return currentState.items
        .where((t) => t.triggers.any((trigger) => triggers.contains(trigger)))
        .toList();
  }

  /// Search temptations by query
  Future<List<Temptation>> search(String query) async {
    if (query.isEmpty) {
      final currentState = await future;
      return currentState.items;
    }

    final repository = ref.read(temptationRepositoryProvider.notifier);
    return await repository.searchTemptations();
  }
}
