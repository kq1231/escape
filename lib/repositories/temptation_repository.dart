import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/temptation_model.dart';

part 'temptation_repository.g.dart';

@Riverpod()
class TemptationRepository extends _$TemptationRepository {
  late Box<Temptation> _temptationBox;

  @override
  FutureOr<void> build() async {
    _temptationBox = ref
        .read(objectboxProvider)
        .requireValue
        .store
        .box<Temptation>();
  }

  // Create a new temptation record
  Future<int> createTemptation(Temptation temptation) async {
    final id = await _temptationBox.putAsync(temptation);
    return id;
  }

  // Get temptation by ID
  Future<Temptation?> getTemptationById(int id) async {
    return await _temptationBox.getAsync(id);
  }

  // Get all temptations
  Future<List<Temptation>> getAllTemptations() async {
    return await _temptationBox.getAllAsync();
  }

  // Get temptations by date range
  Future<List<Temptation>> getTemptationsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final query = _temptationBox
        .query(Temptation_.createdAt.betweenDate(start, end))
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  // Get today's temptations
  Future<List<Temptation>> getTodayTemptations() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    return await getTemptationsByDateRange(startOfDay, endOfDay);
  }

  // Get active temptations (not resolved)
  Future<List<Temptation>> getActiveTemptations() async {
    final query = _temptationBox
        .query(
          Temptation_.resolvedAt.isNull().and(Temptation_.createdAt.notNull()),
        )
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  // Update temptation
  Future<int> updateTemptation(Temptation temptation) async {
    final id = await _temptationBox.putAsync(temptation);
    return id;
  }

  // Delete temptation
  Future<bool> deleteTemptation(int id) async {
    final result = await _temptationBox.removeAsync(id);
    return result;
  }

  // Delete all temptations
  Future<int> deleteAllTemptations() async {
    final count = await _temptationBox.removeAllAsync();
    return count;
  }

  // Get temptation count
  Future<int> getTemptationCount() async {
    final query = _temptationBox.query().build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get successful temptation count
  Future<int> getSuccessfulTemptationCount() async {
    final query = _temptationBox
        .query(Temptation_.wasSuccessful.equals(true))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get relapse count
  Future<int> getRelapseCount() async {
    final query = _temptationBox
        .query(Temptation_.wasSuccessful.equals(false))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get success rate
  Future<double> getSuccessRate() async {
    final total = await getTemptationCount();
    if (total == 0) return 0.0;
    final successful = await getSuccessfulTemptationCount();
    return successful / total;
  }

  // Get successful temptation count for today
  Future<int> getTodaySuccessfulTemptationCount() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final query = _temptationBox
        .query(
          Temptation_.createdAt
              .betweenDate(startOfDay, endOfDay)
              .and(Temptation_.wasSuccessful.equals(true)),
        )
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get relapse count for today
  Future<int> getTodayRelapseCount() async {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);

    final query = _temptationBox
        .query(
          Temptation_.createdAt
              .betweenDate(startOfDay, endOfDay)
              .and(Temptation_.wasSuccessful.equals(false)),
        )
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Watch temptation changes
  Stream<List<Temptation>> watchTemptations() {
    return _temptationBox
        .query()
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync());
  }

  // Watch active temptations
  Stream<List<Temptation>> watchActiveTemptations() {
    return _temptationBox
        .query(
          Temptation_.resolvedAt.isNull().and(Temptation_.createdAt.notNull()),
        )
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync());
  }

  // Resolve temptation (mark as completed)
  Future<void> resolveTemptation(
    int temptationId, {
    bool wasSuccessful = true,
    String? notes,
    int? intensityAfter,
  }) async {
    final temptation = await getTemptationById(temptationId);
    if (temptation != null) {
      final updatedTemptation = temptation.copyWith(
        wasSuccessful: wasSuccessful,
        resolutionNotes: notes,
      );
      await updateTemptation(updatedTemptation);
    }
  }

  // Add trigger to temptation
  Future<void> addTrigger(int temptationId, String trigger) async {
    final temptation = await getTemptationById(temptationId);
    if (temptation != null && !temptation.triggers.contains(trigger)) {
      final updatedTemptation = temptation.copyWith(
        triggers: [...temptation.triggers, trigger],
      );
      await updateTemptation(updatedTemptation);
    }
  }

  // Add helpful activity to temptation
  Future<void> addHelpfulActivity(int temptationId, String activity) async {
    final temptation = await getTemptationById(temptationId);
    if (temptation != null &&
        !temptation.helpfulActivities.contains(activity)) {
      final updatedTemptation = temptation.copyWith(
        helpfulActivities: [...temptation.helpfulActivities, activity],
      );
      await updateTemptation(updatedTemptation);
    }
  }

  // Set selected activity for temptation
  Future<void> setSelectedActivity(int temptationId, String activity) async {
    final temptation = await getTemptationById(temptationId);
    if (temptation != null) {
      final updatedTemptation = temptation.copyWith(selectedActivity: activity);
      await updateTemptation(updatedTemptation);
    }
  }

  // Get temptations by trigger
  Future<List<Temptation>> getTemptationsByTrigger(String trigger) async {
    final query = _temptationBox
        .query(Temptation_.triggers.containsElement(trigger))
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  // Get temptations by helpful activity
  Future<List<Temptation>> getTemptationsByHelpfulActivity(
    String activity,
  ) async {
    final query = _temptationBox
        .query(Temptation_.helpfulActivities.containsElement(activity))
        .build();
    final result = await query.findAsync();
    query.close();
    return result;
  }

  // Get most common triggers
  Future<List<MapEntry<String, int>>> getMostCommonTriggers({
    int limit = 10,
  }) async {
    final triggerCounts = <String, int>{};

    final temptations = await getAllTemptations();
    for (final temptation in temptations) {
      for (final trigger in temptation.triggers) {
        triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
      }
    }

    return triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(limit).toList();
  }

  // Get most helpful activities
  Future<List<MapEntry<String, int>>> getMostHelpfulActivities({
    int limit = 10,
  }) async {
    final activityCounts = <String, int>{};

    final temptations = await getAllTemptations();
    for (final temptation in temptations) {
      for (final activity in temptation.helpfulActivities) {
        activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
      }
    }

    return activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(limit).toList();
  }

  // History-specific methods

  // Get temptations with pagination
  Future<List<Temptation>> getTemptationsWithPagination({
    int offset = 0,
    int limit = 20,
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
  }) async {
    Condition<Temptation>? condition;

    // Build date range condition
    if (startDate != null && endDate != null) {
      condition = Temptation_.createdAt.betweenDate(startDate, endDate);
    } else if (startDate != null) {
      condition = Temptation_.createdAt.greaterOrEqualDate(startDate);
    } else if (endDate != null) {
      condition = Temptation_.createdAt.lessOrEqualDate(endDate);
    }

    // Add success filter
    if (wasSuccessful != null) {
      final successCondition = Temptation_.wasSuccessful.equals(wasSuccessful);
      condition = condition != null
          ? condition.and(successCondition)
          : successCondition;
    }

    // Add resolved filter
    if (isResolved != null) {
      final resolvedCondition = isResolved
          ? Temptation_.resolvedAt.notNull()
          : Temptation_.resolvedAt.isNull();
      condition = condition != null
          ? condition.and(resolvedCondition)
          : resolvedCondition;
    }

    final query = condition != null
        ? _temptationBox.query(condition)
        : _temptationBox.query();

    final queryBuilt = query
        .order(Temptation_.createdAt, flags: Order.descending)
        .build();

    final allResults = await queryBuilt.findAsync();
    queryBuilt.close();

    // Manual pagination
    final startIndex = offset.clamp(0, allResults.length);
    final endIndex = (offset + limit).clamp(0, allResults.length);

    return allResults.sublist(startIndex, endIndex);
  }

  // Search temptations by criteria
  Future<List<Temptation>> searchTemptations({
    DateTime? startDate,
    DateTime? endDate,
    bool? wasSuccessful,
    bool? isResolved,
    String? selectedActivity,
    List<String>? triggers,
  }) async {
    Condition<Temptation>? condition;

    // Build date range condition
    if (startDate != null && endDate != null) {
      condition = Temptation_.createdAt.betweenDate(startDate, endDate);
    }

    // Add success filter
    if (wasSuccessful != null) {
      final successCondition = Temptation_.wasSuccessful.equals(wasSuccessful);
      condition = condition != null
          ? condition.and(successCondition)
          : successCondition;
    }

    // Add resolved filter
    if (isResolved != null) {
      final resolvedCondition = isResolved
          ? Temptation_.resolvedAt.notNull()
          : Temptation_.resolvedAt.isNull();
      condition = condition != null
          ? condition.and(resolvedCondition)
          : resolvedCondition;
    }

    // Add activity filter
    if (selectedActivity != null) {
      final activityCondition = Temptation_.selectedActivity.equals(
        selectedActivity,
      );
      condition = condition != null
          ? condition.and(activityCondition)
          : activityCondition;
    }

    final query = condition != null
        ? _temptationBox.query(condition)
        : _temptationBox.query();

    final queryBuilt = query
        .order(Temptation_.createdAt, flags: Order.descending)
        .build();

    final result = await queryBuilt.findAsync();
    queryBuilt.close();

    // Filter by triggers if provided (since ObjectBox doesn't support list contains queries easily)
    if (triggers != null && triggers.isNotEmpty) {
      return result.where((temptation) {
        return triggers.any((trigger) => temptation.triggers.contains(trigger));
      }).toList();
    }

    return result;
  }

  // Get temptation statistics for a date range
  Future<Map<String, dynamic>> getTemptationStatistics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final temptations = await searchTemptations(
      startDate: startDate,
      endDate: endDate,
      isResolved: true, // Only count resolved temptations for statistics
    );

    if (temptations.isEmpty) {
      return {
        'totalTemptations': 0,
        'successfulTemptations': 0,
        'relapses': 0,
        'successRate': 0.0,
        'averageDuration': 0.0,
        'commonTriggers': <String>[],
        'effectiveActivities': <String>[],
      };
    }

    final successfulTemptations = temptations
        .where((t) => t.wasSuccessful)
        .length;
    final relapses = temptations.where((t) => !t.wasSuccessful).length;

    // Calculate average duration
    final durationsInMinutes = temptations
        .where((t) => t.duration != null)
        .map((t) => t.duration!.inMinutes)
        .toList();
    final averageDuration = durationsInMinutes.isNotEmpty
        ? durationsInMinutes.reduce((a, b) => a + b) / durationsInMinutes.length
        : 0.0;

    // Get common triggers
    final Map<String, int> triggerCounts = {};
    for (final temptation in temptations) {
      for (final trigger in temptation.triggers) {
        triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
      }
    }
    final commonTriggers = triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Get effective activities (from successful temptations)
    final Map<String, int> activityCounts = {};
    for (final temptation in temptations.where((t) => t.wasSuccessful)) {
      if (temptation.selectedActivity != null) {
        activityCounts[temptation.selectedActivity!] =
            (activityCounts[temptation.selectedActivity!] ?? 0) + 1;
      }
    }
    final effectiveActivities = activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return {
      'totalTemptations': temptations.length,
      'successfulTemptations': successfulTemptations,
      'relapses': relapses,
      'successRate': temptations.isNotEmpty
          ? (successfulTemptations / temptations.length) * 100
          : 0.0,
      'averageDuration': averageDuration,
      'commonTriggers': commonTriggers.take(5).map((e) => e.key).toList(),
      'effectiveActivities': effectiveActivities
          .take(5)
          .map((e) => e.key)
          .toList(),
    };
  }

  // Get temptations grouped by date
  Future<Map<String, List<Temptation>>> getTemptationsGroupedByDate({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    final temptations = await searchTemptations(
      startDate: startDate,
      endDate: endDate,
    );

    final Map<String, List<Temptation>> groupedTemptations = {};

    for (final temptation in temptations) {
      final dateKey =
          '${temptation.createdAt.year}-${temptation.createdAt.month.toString().padLeft(2, '0')}-${temptation.createdAt.day.toString().padLeft(2, '0')}';
      if (!groupedTemptations.containsKey(dateKey)) {
        groupedTemptations[dateKey] = [];
      }
      groupedTemptations[dateKey]!.add(temptation);
    }

    return groupedTemptations;
  }
}
