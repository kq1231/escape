import 'dart:convert';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:escape/objectbox.g.dart';
import '../models/challenge_model.dart';
import '../models/streak_model.dart';
import '../models/prayer_model.dart';
import '../models/temptation_model.dart';
import 'objectbox_provider.dart';

part 'challenges_repository_provider.g.dart';

/// A provider that handles all challenge-related operations
/// This repository manages challenges and their validation logic
@Riverpod(keepAlive: true)
class ChallengesRepository extends _$ChallengesRepository {
  late Box<Challenge> _challengeBox;
  late Box<Streak> _streakBox;
  late Box<Prayer> _prayerBox;
  late Box<Temptation> _temptationBox;

  @override
  Future<void> build() async {
    // Initialize the repository
    await _initialize();
  }

  /// Initialize the repository
  Future<void> _initialize() async {
    // Wait for ObjectBox to be initialized and get the store
    final store = ref.read(objectboxProvider).requireValue.store;

    // Initialize all boxes
    _challengeBox = store.box<Challenge>();
    _streakBox = store.box<Streak>();
    _prayerBox = store.box<Prayer>();
    _temptationBox = store.box<Temptation>();
  }

  /// Stream of all challenges (for challenges screen)
  Stream<List<Challenge>> watchAllChallenges() {
    return _challengeBox
        .query()
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync())
        .map(
          (entities) => entities
              .map(
                (entity) => Challenge(
                  id: entity.id,
                  title: entity.title,
                  description: entity.description,
                  featureName: entity.featureName,
                  conditionJson: entity.conditionJson,
                  iconPath: entity.iconPath,
                  isCompleted: entity.isCompleted,
                  completedAt: entity.completedAt,
                  xp: entity.xp,
                ),
              )
              .toList(),
        );
  }

  /// Stream of streak data for challenge validation
  Stream<List<Streak>> watchStreakData() {
    return _streakBox
        .query()
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync())
        .map(
          (entities) => entities
              .map(
                (entity) => Streak(
                  id: entity.id,
                  count: entity.count,
                  goal: entity.goal,
                  date: entity.date,
                  emotion: entity.emotion,
                  moodIntensity: entity.moodIntensity,
                  createdAt: entity.createdAt,
                  lastUpdated: entity.lastUpdated,
                  isSuccess: entity.isSuccess,
                ),
              )
              .toList(),
        );
  }

  /// Stream of prayer data for challenge validation
  Stream<List<Prayer>> watchPrayerData() {
    return _prayerBox
        .query()
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync())
        .map(
          (entities) => entities
              .map(
                (entity) => Prayer(
                  id: entity.id,
                  name: entity.name,
                  isCompleted: entity.isCompleted,
                  date: entity.date,
                ),
              )
              .toList(),
        );
  }

  /// Stream of temptation data for challenge validation
  Stream<List<Temptation>> watchTemptationData() {
    return _temptationBox
        .query()
        .watch(triggerImmediately: true)
        .asyncMap((query) async => await query.findAsync())
        .map(
          (entities) => entities
              .map(
                (entity) => Temptation(
                  id: entity.id,
                  createdAt: entity.createdAt,
                  triggers: entity.triggers,
                  helpfulActivities: entity.helpfulActivities,
                  selectedActivity: entity.selectedActivity,
                  wasSuccessful: entity.wasSuccessful,
                  resolutionNotes: entity.resolutionNotes,
                  intensityBefore: entity.intensityBefore,
                  intensityAfter: entity.intensityAfter,
                ),
              )
              .toList(),
        );
  }

  /// Fetch all challenges
  Future<List<Challenge>> fetchAllChallenges() async {
    final entities = _challengeBox.getAll();
    return entities
        .map(
          (entity) => Challenge(
            id: entity.id,
            title: entity.title,
            description: entity.description,
            featureName: entity.featureName,
            conditionJson: entity.conditionJson,
            iconPath: entity.iconPath,
            isCompleted: entity.isCompleted,
            completedAt: entity.completedAt,
            xp: entity.xp,
          ),
        )
        .toList();
  }

  /// Check if a challenge condition is met
  bool isChallengeMet(Challenge challenge) {
    if (challenge.isCompleted) return false;

    return switch (challenge.featureName) {
      'streak' => _evaluateCondition(
        jsonDecode(challenge.conditionJson),
        _getStreakQueryBuilder(),
      ),
      'prayer' => _evaluateCondition(
        jsonDecode(challenge.conditionJson),
        _getPrayerQueryBuilder(),
      ),
      'temptation' => _evaluateCondition(
        jsonDecode(challenge.conditionJson),
        _getTemptationQueryBuilder(),
      ),
      _ => false, // Unknown feature name
    };
  }

  /// Generic condition evaluator
  bool _evaluateCondition(
    Map<String, dynamic> condition,
    dynamic queryBuilder,
  ) {
    // Check if this is a logical operator (AND/OR)
    if (condition.containsKey('operator') &&
        (condition['operator'] == 'AND' || condition['operator'] == 'OR')) {
      return _evaluateLogicalCondition(condition, queryBuilder);
    }

    // Single condition
    return _evaluateSingleCondition(condition, queryBuilder);
  }

  /// Handle AND/OR conditions
  bool _evaluateLogicalCondition(
    Map<String, dynamic> condition,
    dynamic queryBuilder,
  ) {
    final operator = condition['operator'] as String;
    final conditions = condition['conditions'] as List<dynamic>;

    if (operator == 'AND') {
      // All conditions must be true
      return conditions.every((cond) => _evaluateCondition(cond, queryBuilder));
    } else if (operator == 'OR') {
      // At least one condition must be true
      return conditions.any((cond) => _evaluateCondition(cond, queryBuilder));
    }

    return false;
  }

  /// Evaluate single field condition
  bool _evaluateSingleCondition(
    Map<String, dynamic> condition,
    dynamic queryBuilder,
  ) {
    final field = condition['field'] as String;
    final operator = condition['operator'] as String;
    final value = condition['value'];

    // Build the query based on field and operator
    final query = _buildFieldQuery(queryBuilder, field, operator, value);
    return query?.build().findFirst() != null;
  }

  /// Build ObjectBox query for specific field/operator/value
  dynamic _buildFieldQuery(
    dynamic queryBuilder,
    String field,
    String operator,
    dynamic value,
  ) {
    // This will be feature-specific implementation
    return null; // Implemented in feature-specific methods below
  }

  /// Feature-specific query builders
  dynamic _getStreakQueryBuilder() {
    return _streakBox.query();
  }

  dynamic _getPrayerQueryBuilder() {
    return _prayerBox.query();
  }

  dynamic _getTemptationQueryBuilder() {
    return _temptationBox.query();
  }

  /// Mark challenge as completed
  Future<void> markChallengeCompleted(int challengeId) async {
    final challenge = _challengeBox
        .query(Challenge_.id.equals(challengeId))
        .build()
        .findFirst();
    if (challenge != null) {
      challenge.isCompleted = true;
      challenge.completedAt = DateTime.now();
      _challengeBox.put(challenge);
    }
  }

  /// Get all incomplete challenges that are ready to be completed
  Future<List<Challenge>> getReadyToCompleteChallenges() async {
    final allChallenges = await fetchAllChallenges();
    return allChallenges
        .where(
          (challenge) => !challenge.isCompleted && isChallengeMet(challenge),
        )
        .toList();
  }
}
