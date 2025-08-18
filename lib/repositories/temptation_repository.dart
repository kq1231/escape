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
    final id = _temptationBox.put(temptation);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Get temptation by ID
  Temptation? getTemptationById(int id) {
    return _temptationBox.get(id);
  }

  // Get all temptations
  List<Temptation> getAllTemptations() {
    return _temptationBox.getAll();
  }

  // Get temptations by date range
  List<Temptation> getTemptationsByDateRange(DateTime start, DateTime end) {
    final query = _temptationBox
        .query(Temptation_.createdAt.betweenDate(start, end))
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get today's temptations
  List<Temptation> getTodayTemptations() {
    final today = DateTime.now();
    final startOfDay = DateTime(today.year, today.month, today.day);
    final endOfDay = DateTime(today.year, today.month, today.day, 23, 59, 59);
    return getTemptationsByDateRange(startOfDay, endOfDay);
  }

  // Get active temptations (not resolved)
  List<Temptation> getActiveTemptations() {
    final query = _temptationBox
        .query(
          Temptation_.resolvedAt.isNull().and(Temptation_.createdAt.notNull()),
        )
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Update temptation
  Future<int> updateTemptation(Temptation temptation) async {
    final id = _temptationBox.put(temptation);
    // Refresh the state
    ref.invalidateSelf();
    return id;
  }

  // Delete temptation
  Future<bool> deleteTemptation(int id) async {
    final result = _temptationBox.remove(id);
    // Refresh the state
    ref.invalidateSelf();
    return result;
  }

  // Delete all temptations
  Future<int> deleteAllTemptations() async {
    final count = _temptationBox.removeAll();
    // Refresh the state
    ref.invalidateSelf();
    return count;
  }

  // Get temptation count
  int getTemptationCount() {
    return _temptationBox.count();
  }

  // Get successful temptation count
  int getSuccessfulTemptationCount() {
    final query = _temptationBox
        .query(Temptation_.wasSuccessful.equals(true))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get relapse count
  int getRelapseCount() {
    final query = _temptationBox
        .query(Temptation_.wasSuccessful.equals(false))
        .build();
    final count = query.count();
    query.close();
    return count;
  }

  // Get success rate
  double getSuccessRate() {
    final total = getTemptationCount();
    if (total == 0) return 0.0;
    final successful = getSuccessfulTemptationCount();
    return successful / total;
  }

  // Get successful temptation count for today
  int getTodaySuccessfulTemptationCount() {
    final todayTemptations = getTodayTemptations();
    return todayTemptations.where((t) => t.wasSuccessful).length;
  }

  // Get relapse count for today
  int getTodayRelapseCount() {
    final todayTemptations = getTodayTemptations();
    return todayTemptations.where((t) => !t.wasSuccessful).length;
  }

  // Watch temptation changes
  Stream<List<Temptation>> watchTemptations() {
    return _temptationBox
        .query()
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  // Watch active temptations
  Stream<List<Temptation>> watchActiveTemptations() {
    return _temptationBox
        .query(
          Temptation_.resolvedAt.isNull().and(Temptation_.createdAt.notNull()),
        )
        .watch(triggerImmediately: true)
        .map((query) => query.find());
  }

  // Resolve temptation (mark as completed)
  Future<void> resolveTemptation(
    int temptationId, {
    bool wasSuccessful = true,
    String? notes,
    int? intensityAfter,
  }) async {
    final temptation = getTemptationById(temptationId);
    if (temptation != null) {
      final updatedTemptation = temptation.copyWith(
        resolvedAt: DateTime.now(),
        wasSuccessful: wasSuccessful,
        resolutionNotes: notes,
        intensityAfter: intensityAfter,
      );
      await updateTemptation(updatedTemptation);
    }
  }

  // Add trigger to temptation
  Future<void> addTrigger(int temptationId, String trigger) async {
    final temptation = getTemptationById(temptationId);
    if (temptation != null && !temptation.triggers.contains(trigger)) {
      final updatedTemptation = temptation.copyWith(
        triggers: [...temptation.triggers, trigger],
      );
      await updateTemptation(updatedTemptation);
    }
  }

  // Add helpful activity to temptation
  Future<void> addHelpfulActivity(int temptationId, String activity) async {
    final temptation = getTemptationById(temptationId);
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
    final temptation = getTemptationById(temptationId);
    if (temptation != null) {
      final updatedTemptation = temptation.copyWith(selectedActivity: activity);
      await updateTemptation(updatedTemptation);
    }
  }

  // Set intensity before temptation
  Future<void> setIntensityBefore(int temptationId, int intensity) async {
    final temptation = getTemptationById(temptationId);
    if (temptation != null) {
      final updatedTemptation = temptation.copyWith(intensityBefore: intensity);
      await updateTemptation(updatedTemptation);
    }
  }

  // Get temptations by trigger
  List<Temptation> getTemptationsByTrigger(String trigger) {
    final query = _temptationBox
        .query(Temptation_.triggers.containsElement(trigger))
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get temptations by helpful activity
  List<Temptation> getTemptationsByHelpfulActivity(String activity) {
    final query = _temptationBox
        .query(Temptation_.helpfulActivities.containsElement(activity))
        .build();
    final result = query.find();
    query.close();
    return result;
  }

  // Get most common triggers
  List<MapEntry<String, int>> getMostCommonTriggers({int limit = 10}) {
    final triggerCounts = <String, int>{};

    for (final temptation in getAllTemptations()) {
      for (final trigger in temptation.triggers) {
        triggerCounts[trigger] = (triggerCounts[trigger] ?? 0) + 1;
      }
    }

    return triggerCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(limit).toList();
  }

  // Get most helpful activities
  List<MapEntry<String, int>> getMostHelpfulActivities({int limit = 10}) {
    final activityCounts = <String, int>{};

    for (final temptation in getAllTemptations()) {
      for (final activity in temptation.helpfulActivities) {
        activityCounts[activity] = (activityCounts[activity] ?? 0) + 1;
      }
    }

    return activityCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value))
      ..take(limit).toList();
  }
}
