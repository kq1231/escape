import 'package:escape/models/temptation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../repositories/temptation_repository.dart';

part 'temptation_provider.g.dart';

/// A provider that handles all temptation-related operations
/// This provider has keepAlive: false (autoDispose) for efficiency
@Riverpod(keepAlive: false)
class ActiveTemptations extends _$ActiveTemptations {
  @override
  Stream<List<Temptation>> build() async* {
    Stream<List<Temptation>> stream = ref
        .watch(temptationRepositoryProvider.notifier)
        .watchActiveTemptations();

    // Watch the temptation repository for changes
    yield* stream;
  }

  /// Resolve an active temptation
  Future<void> resolveTemptation(
    int temptationId, {
    bool wasSuccessful = true,
    String? notes,
    int? intensityAfter,
  }) async {
    await ref
        .read(temptationRepositoryProvider.notifier)
        .resolveTemptation(
          temptationId,
          wasSuccessful: wasSuccessful,
          notes: notes,
          intensityAfter: intensityAfter,
        );
  }

  /// Add a trigger to an active temptation
  Future<void> addTrigger(int temptationId, String trigger) async {
    await ref
        .read(temptationRepositoryProvider.notifier)
        .addTrigger(temptationId, trigger);
  }

  /// Add a helpful activity to an active temptation
  Future<void> addHelpfulActivity(int temptationId, String activity) async {
    await ref
        .read(temptationRepositoryProvider.notifier)
        .addHelpfulActivity(temptationId, activity);
  }

  /// Set the selected activity for an active temptation
  Future<void> setSelectedActivity(int temptationId, String activity) async {
    await ref
        .read(temptationRepositoryProvider.notifier)
        .setSelectedActivity(temptationId, activity);
  }

  /// Set intensity before for an active temptation
  Future<void> setIntensityBefore(int temptationId, int intensity) async {
    await ref
        .read(temptationRepositoryProvider.notifier)
        .setIntensityBefore(temptationId, intensity);
  }
}

/// Provider for all temptations history
@Riverpod(keepAlive: false)
class AllTemptations extends _$AllTemptations {
  @override
  Stream<List<Temptation>> build() async* {
    Stream<List<Temptation>> stream = ref
        .watch(temptationRepositoryProvider.notifier)
        .watchTemptations();

    // Watch the temptation repository for changes
    yield* stream;
  }

  /// Delete a temptation
  Future<bool> deleteTemptation(int id) async {
    return await ref
        .read(temptationRepositoryProvider.notifier)
        .deleteTemptation(id);
  }
}

/// Provider for today's temptations
@Riverpod(keepAlive: false)
class TodaysTemptations extends _$TodaysTemptations {
  @override
  List<Temptation> build() {
    return ref
        .read(temptationRepositoryProvider.notifier)
        .getTodayTemptations();
  }

  /// Get today's successful temptations count
  int get successfulCount {
    return state.where((t) => t.wasSuccessful).length;
  }

  /// Get today's relapse count
  int get relapseCount {
    return state.where((t) => !t.wasSuccessful).length;
  }

  /// Get today's success rate
  double get successRate {
    if (state.isEmpty) return 0.0;
    return successfulCount / state.length;
  }
}

/// Provider for temptation statistics
@Riverpod(keepAlive: true)
class TemptationStats extends _$TemptationStats {
  @override
  Future<Map<String, dynamic>> build() async {
    final repository = ref.read(temptationRepositoryProvider.notifier);

    return {
      'total': repository.getTemptationCount(),
      'successful': repository.getSuccessfulTemptationCount(),
      'relapses': repository.getRelapseCount(),
      'successRate': repository.getSuccessRate(),
      'todaySuccessful': repository.getTodaySuccessfulTemptationCount(),
      'todayRelapses': repository.getTodayRelapseCount(),
      'todaySuccessRate':
          repository.getTodaySuccessfulTemptationCount() /
          (repository.getTodayTemptations().length).clamp(1, double.maxFinite),
      'mostCommonTriggers': repository.getMostCommonTriggers(limit: 5),
      'mostHelpfulActivities': repository.getMostHelpfulActivities(limit: 5),
    };
  }

  /// Refresh statistics
  Future<void> refresh() async {
    ref.invalidateSelf();
  }
}

/// Provider for checking if there's an active temptation
@Riverpod(keepAlive: false)
class HasActiveTemptation extends _$HasActiveTemptation {
  @override
  bool build() {
    final activeTemptations = ref.watch(activeTemptationsProvider).requireValue;
    return activeTemptations.isNotEmpty;
  }
}

/// Provider for the current active temptation (if any)
@Riverpod(keepAlive: false)
class CurrentActiveTemptation extends _$CurrentActiveTemptation {
  @override
  Temptation? build() {
    final activeTemptations = ref.watch(activeTemptationsProvider).requireValue;
    return activeTemptations.isNotEmpty ? activeTemptations.first : null;
  }
}

/// Provider for creating a new temptation
@Riverpod(keepAlive: false)
class CreateTemptation extends _$CreateTemptation {
  @override
  Future<Temptation> build() async {
    final newTemptation = Temptation(createdAt: DateTime.now());

    final id = await ref
        .read(temptationRepositoryProvider.notifier)
        .createTemptation(newTemptation);
    return ref
        .read(temptationRepositoryProvider.notifier)
        .getTemptationById(id)!;
  }

  /// Create a temptation with selected activity
  Future<Temptation> createWithActivity(String selectedActivity) async {
    final newTemptation = Temptation(createdAt: DateTime.now())
      ..selectedActivity = selectedActivity;

    final id = await ref
        .read(temptationRepositoryProvider.notifier)
        .createTemptation(newTemptation);
    return ref
        .read(temptationRepositoryProvider.notifier)
        .getTemptationById(id)!;
  }
}
