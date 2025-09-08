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

  /// Enhanced logical condition evaluator for complex challenges
  bool _evaluateLogicalCondition(
    Map<String, dynamic> condition,
    dynamic queryBuilder,
  ) {
    final operator = condition['operator'] as String;
    final conditions = condition['conditions'] as List<dynamic>;

    if (operator == 'AND') {
      // All conditions must be true
      return conditions.every((cond) {
        // For AND conditions, we might need different query builders for different features
        final condMap = cond as Map<String, dynamic>;
        final field = condMap['field'] as String;

        // Determine which query builder to use based on field
        dynamic appropriateQueryBuilder = queryBuilder;
        if (field == 'streak_count') {
          appropriateQueryBuilder = _getStreakQueryBuilder();
        } else if (field.contains('prayer') ||
            field.contains('reflection') ||
            field.contains('gratitude') ||
            field.contains('tahajjud')) {
          appropriateQueryBuilder = _getPrayerQueryBuilder();
        } else if (field.contains('success') || field.contains('temptation')) {
          appropriateQueryBuilder = _getTemptationQueryBuilder();
        }

        return _evaluateCondition(cond, appropriateQueryBuilder);
      });
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

    // Handle count-based conditions that need aggregation
    if (field.contains('count') ||
        field.contains('entries') ||
        field.contains('completed')) {
      return _evaluateCountCondition(queryBuilder, field, operator, value);
    }

    // For non-count conditions, build and execute the query
    Query<dynamic>? query;

    if (queryBuilder is QueryBuilder<Streak>) {
      query = _buildStreakQuery(queryBuilder, field, operator, value);
    } else if (queryBuilder is QueryBuilder<Prayer>) {
      query = _buildPrayerQuery(queryBuilder, field, operator, value);
    } else if (queryBuilder is QueryBuilder<Temptation>) {
      query = _buildTemptationQuery(queryBuilder, field, operator, value);
    }

    if (query != null) {
      final result = query.findFirst() != null;
      query.close();
      return result;
    }

    return false;
  }

  /// Evaluate count-based conditions with proper aggregation
  bool _evaluateCountCondition(
    dynamic queryBuilder,
    String field,
    String operator,
    dynamic expectedValue,
  ) {
    int actualCount = 0;

    if (queryBuilder is QueryBuilder<Streak>) {
      actualCount = _getStreakCount(field);
    } else if (queryBuilder is QueryBuilder<Prayer>) {
      actualCount = _getPrayerCount(field);
    } else if (queryBuilder is QueryBuilder<Temptation>) {
      actualCount = _getTemptationCount(field);
    }

    // Apply the operator to compare actual vs expected count
    return switch (operator) {
      '>=' => actualCount >= (expectedValue as int),
      '>' => actualCount > (expectedValue as int),
      '==' || '=' => actualCount == (expectedValue as int),
      '<' => actualCount < (expectedValue as int),
      '<=' => actualCount <= (expectedValue as int),
      _ => false,
    };
  }

  /// Get count for streak-related fields
  int _getStreakCount(String field) {
    switch (field) {
      case 'count':
        // Get the latest streak count
        final latestStreak = _streakBox
            .query()
            .order(Streak_.createdAt, flags: Order.descending)
            .build()
            .findFirst();
        return latestStreak?.count ?? 0;

      default:
        return _streakBox.count();
    }
  }

  /// Get count for prayer-related fields
  int _getPrayerCount(String field) {
    switch (field) {
      case 'morning_reflection':
        // Count morning reflection prayers in the last N days
        final days =
            7; // Default to 7 days, you might want to extract this from condition
        final startDate = DateTime.now().subtract(Duration(days: days));
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Morning Reflection')
                  .and(Prayer_.isCompleted.equals(true))
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build()
            .count();

      case 'daily_prayers_completed':
        // Count all completed prayers
        return _prayerBox
            .query(Prayer_.isCompleted.equals(true))
            .build()
            .count();

      case 'monthly_prayers_completed':
        // Count prayers completed in the last 30 days
        final startDate = DateTime.now().subtract(const Duration(days: 30));
        return _prayerBox
            .query(
              Prayer_.isCompleted
                  .equals(true)
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build()
            .count();

      case 'gratitude_entries':
        // Count gratitude journal entries
        final days = 7; // Default to 7 days
        final startDate = DateTime.now().subtract(Duration(days: days));
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Gratitude Journal')
                  .and(Prayer_.isCompleted.equals(true))
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build()
            .count();

      case 'tahajjud_count':
        // Count Tahajjud prayers
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Tahajjud')
                  .and(Prayer_.isCompleted.equals(true)),
            )
            .build()
            .count();

      default:
        return _prayerBox.count();
    }
  }

  /// Get count for temptation-related fields
  int _getTemptationCount(String field) {
    switch (field) {
      case 'count':
        // Total number of temptations recorded
        return _temptationBox.count();

      case 'success_count':
        // Count of successfully overcome temptations
        return _temptationBox
            .query(Temptation_.wasSuccessful.equals(true))
            .build()
            .count();

      case 'streak_count':
        // For complex challenges that reference streak count from temptation context
        // Get the current streak count
        final latestStreak = _streakBox
            .query()
            .order(Streak_.createdAt, flags: Order.descending)
            .build()
            .findFirst();
        return latestStreak?.count ?? 0;

      default:
        return _temptationBox.count();
    }
  }

  /// Build queries for Streak entity
  Query<Streak>? _buildStreakQuery(
    QueryBuilder<Streak> queryBuilder,
    String field,
    String operator,
    dynamic value,
  ) {
    switch (field) {
      case 'count':
        switch (operator) {
          case '>=':
            return _streakBox
                .query(Streak_.count.greaterOrEqual(value as int))
                .build();
          case '>':
            return _streakBox
                .query(Streak_.count.greaterThan(value as int))
                .build();
          case '==':
          case '=':
            return _streakBox.query(Streak_.count.equals(value as int)).build();
          case '<':
            return _streakBox
                .query(Streak_.count.lessThan(value as int))
                .build();
          case '<=':
            return _streakBox
                .query(Streak_.count.lessOrEqual(value as int))
                .build();
          default:
            return null;
        }

      case 'goal':
        switch (operator) {
          case '>=':
            return _streakBox
                .query(Streak_.goal.greaterOrEqual(value as int))
                .build();
          case '>':
            return _streakBox
                .query(Streak_.goal.greaterThan(value as int))
                .build();
          case '==':
          case '=':
            return _streakBox.query(Streak_.goal.equals(value as int)).build();
          case '<':
            return _streakBox
                .query(Streak_.goal.lessThan(value as int))
                .build();
          case '<=':
            return _streakBox
                .query(Streak_.goal.lessOrEqual(value as int))
                .build();
          default:
            return null;
        }

      case 'isSuccess':
        if (operator == '==' || operator == '=') {
          return _streakBox
              .query(Streak_.isSuccess.equals(value as bool))
              .build();
        }
        break;

      case 'date':
        DateTime dateValue;
        if (value is String) {
          dateValue = DateTime.parse(value);
        } else if (value is DateTime) {
          dateValue = value;
        } else {
          return null;
        }

        switch (operator) {
          case '>=':
            return _streakBox
                .query(Streak_.date.greaterOrEqualDate(dateValue))
                .build();
          case '>':
            return _streakBox
                .query(Streak_.date.greaterThanDate(dateValue))
                .build();
          case '==':
          case '=':
            return _streakBox.query(Streak_.date.equalsDate(dateValue)).build();
          case '<':
            return _streakBox
                .query(Streak_.date.lessThanDate(dateValue))
                .build();
          case '<=':
            return _streakBox
                .query(Streak_.date.lessOrEqualDate(dateValue))
                .build();
          default:
            return null;
        }

      default:
        return null;
    }
    return null;
  }

  /// Build queries for Prayer entity
  Query<Prayer>? _buildPrayerQuery(
    QueryBuilder<Prayer> queryBuilder,
    String field,
    String operator,
    dynamic value,
  ) {
    switch (field) {
      case 'name':
        if (operator == '==' || operator == '=') {
          return _prayerBox.query(Prayer_.name.equals(value as String)).build();
        }
        break;

      case 'isCompleted':
        if (operator == '==' || operator == '=') {
          return _prayerBox
              .query(Prayer_.isCompleted.equals(value as bool))
              .build();
        }
        break;

      case 'date':
        DateTime dateValue;
        if (value is String) {
          dateValue = DateTime.parse(value);
        } else if (value is DateTime) {
          dateValue = value;
        } else {
          return null;
        }

        switch (operator) {
          case '>=':
            return _prayerBox
                .query(Prayer_.date.greaterOrEqualDate(dateValue))
                .build();
          case '>':
            return _prayerBox
                .query(Prayer_.date.greaterThanDate(dateValue))
                .build();
          case '==':
          case '=':
            return _prayerBox.query(Prayer_.date.equalsDate(dateValue)).build();
          case '<':
            return _prayerBox
                .query(Prayer_.date.lessThanDate(dateValue))
                .build();
          case '<=':
            return _prayerBox
                .query(Prayer_.date.lessOrEqualDate(dateValue))
                .build();
          default:
            return null;
        }

      // Custom aggregation fields for challenges
      case 'morning_reflection':
        // Count of morning reflection prayers in the last N days
        final days = value as int;
        final startDate = DateTime.now().subtract(Duration(days: days));
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Morning Reflection')
                  .and(Prayer_.isCompleted.equals(true))
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build();

      case 'daily_prayers_completed':
        // Count of all completed prayers
        return _prayerBox.query(Prayer_.isCompleted.equals(true)).build();

      case 'monthly_prayers_completed':
        // Count of prayers completed in the last 30 days
        final startDate = DateTime.now().subtract(const Duration(days: 30));
        return _prayerBox
            .query(
              Prayer_.isCompleted
                  .equals(true)
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build();

      case 'gratitude_entries':
        // Count of gratitude journal entries
        final days = value as int;
        final startDate = DateTime.now().subtract(Duration(days: days));
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Gratitude Journal')
                  .and(Prayer_.isCompleted.equals(true))
                  .and(Prayer_.date.greaterOrEqualDate(startDate)),
            )
            .build();

      case 'tahajjud_count':
        // Count of Tahajjud prayers
        return _prayerBox
            .query(
              Prayer_.name
                  .equals('Tahajjud')
                  .and(Prayer_.isCompleted.equals(true)),
            )
            .build();

      default:
        return null;
    }
    return null;
  }

  /// Build queries for Temptation entity
  Query<Temptation>? _buildTemptationQuery(
    QueryBuilder<Temptation> queryBuilder,
    String field,
    String operator,
    dynamic value,
  ) {
    switch (field) {
      case 'count':
        // For count, we just need any temptation records
        return _temptationBox.query().build();

      case 'success_count':
        // Count of successful temptation overcoming
        return _temptationBox
            .query(Temptation_.wasSuccessful.equals(true))
            .build();

      case 'wasSuccessful':
        if (operator == '==' || operator == '=') {
          return _temptationBox
              .query(Temptation_.wasSuccessful.equals(value as bool))
              .build();
        }
        break;

      case 'createdAt':
        DateTime dateValue;
        if (value is String) {
          dateValue = DateTime.parse(value);
        } else if (value is DateTime) {
          dateValue = value;
        } else {
          return null;
        }

        switch (operator) {
          case '>=':
            return _temptationBox
                .query(Temptation_.createdAt.greaterOrEqualDate(dateValue))
                .build();
          case '>':
            return _temptationBox
                .query(Temptation_.createdAt.greaterThanDate(dateValue))
                .build();
          case '==':
          case '=':
            return _temptationBox
                .query(Temptation_.createdAt.equalsDate(dateValue))
                .build();
          case '<':
            return _temptationBox
                .query(Temptation_.createdAt.lessThanDate(dateValue))
                .build();
          case '<=':
            return _temptationBox
                .query(Temptation_.createdAt.lessOrEqualDate(dateValue))
                .build();
          default:
            return null;
        }

      // For complex conditions like streak_count in temptation challenges
      case 'streak_count':
        // This requires cross-entity validation - check current streak
        // For now, return a query that gets all temptations and we'll validate separately
        return _temptationBox.query().build();

      default:
        return null;
    }
    return null;
  }

  /// Feature-specific query builders
  QueryBuilder<Streak> _getStreakQueryBuilder() {
    return _streakBox.query();
  }

  QueryBuilder<Prayer> _getPrayerQueryBuilder() {
    return _prayerBox.query();
  }

  QueryBuilder<Temptation> _getTemptationQueryBuilder() {
    return _temptationBox.query();
  }

  /// Mark challenge as completed
  Future<void> markChallengeCompleted(Challenge challenge) async {
    challenge.isCompleted = true;
    challenge.completedAt = DateTime.now();
    await _challengeBox.putAsync(challenge);
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
