import 'package:escape/objectbox.g.dart';
import 'package:escape/providers/objectbox_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'dart:async';
import '../models/temptation.dart';

part 'temptation_repository.g.dart';

@Riverpod(keepAlive: false)
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
}
