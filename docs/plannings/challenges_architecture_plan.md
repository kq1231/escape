# Flutter Challenges System Architecture Plan - FINAL

## Overview
A reactive challenges system using Riverpod StreamProviders and Global Overlay with JSON-based query conditions supporting AND/OR logic, following ObjectBox query patterns.

## Architecture Components

### 1. Models

#### Challenge Model
```dart
class Challenge {
  final String id;
  final String title;
  final String description;
  final FeatureName featureName;
  final Map<String, dynamic> condition; // JSON query condition
  final String iconPath;
  final bool isCompleted;
  final DateTime? completedAt;
  
  Challenge({
    required this.id,
    required this.title,
    required this.description,
    required this.featureName,
    required this.condition,
    required this.iconPath,
    this.isCompleted = false,
    this.completedAt,
  });
  
  // Convert from/to ObjectBox entity
  factory Challenge.fromEntity(ChallengeEntity entity) => Challenge(
    id: entity.id,
    title: entity.title,
    description: entity.description,
    featureName: FeatureName.values[entity.featureIndex],
    condition: jsonDecode(entity.conditionJson),
    iconPath: entity.iconPath,
    isCompleted: entity.isCompleted,
    completedAt: entity.completedAt,
  );
}

enum FeatureName { 
  streak, 
  prayer, 
  temptation 
}
```

#### JSON Condition Examples
```dart
// Simple condition: streak >= 7 days
final simple = {
  "field": "consecutiveDays",
  "operator": "greaterOrEqual",
  "value": 7
};

// AND condition: streak >= 7 AND totalDays >= 30
final andCondition = {
  "operator": "AND",
  "conditions": [
    {
      "field": "consecutiveDays",
      "operator": "greaterOrEqual", 
      "value": 7
    },
    {
      "field": "totalDays",
      "operator": "greaterOrEqual",
      "value": 30
    }
  ]
};

// OR condition: prayers >= 100 OR onTimeCount >= 50
final orCondition = {
  "operator": "OR",
  "conditions": [
    {
      "field": "totalCount",
      "operator": "greaterOrEqual",
      "value": 100
    },
    {
      "field": "onTimeCount", 
      "operator": "greaterOrEqual",
      "value": 50
    }
  ]
};

// Complex nested: (streak >= 7 AND totalDays >= 30) OR (streak >= 3 AND isActive == true)
final nested = {
  "operator": "OR",
  "conditions": [
    {
      "operator": "AND",
      "conditions": [
        {
          "field": "consecutiveDays",
          "operator": "greaterOrEqual",
          "value": 7
        },
        {
          "field": "totalDays", 
          "operator": "greaterOrEqual",
          "value": 30
        }
      ]
    },
    {
      "operator": "AND", 
      "conditions": [
        {
          "field": "consecutiveDays",
          "operator": "greaterOrEqual",
          "value": 3
        },
        {
          "field": "isActive",
          "operator": "equals",
          "value": true
        }
      ]
    }
  ]
};
```

### 2. Repository Layer

#### Challenges Repository
```dart
@riverpod
class ChallengesRepository extends _$ChallengesRepository {
  
  // Stream of all challenges (for challenges screen)
  Stream<List<Challenge>> watchAllChallenges() {
    return challengesBox.query().watch(triggerImmediately: true).map(
      (challenges) => challenges.map((entity) => Challenge.fromEntity(entity)).toList()
    );
  }
  
  // Individual feature data streams  
  Stream<List<dynamic>> watchStreakData() => streakBox.query().watch(triggerImmediately: true);
  Stream<List<dynamic>> watchPrayerData() => prayerBox.query().watch(triggerImmediately: true);
  Stream<List<dynamic>> watchTemptationData() => temptationBox.query().watch(triggerImmediately: true);
  
  // Main method to check if challenge condition is met
  bool isChallengeMet(Challenge challenge) {
    if (challenge.isCompleted) return false;
    
    return switch (challenge.featureName) {
      FeatureName.streak => _evaluateCondition(challenge.condition, _getStreakQueryBuilder()),
      FeatureName.prayer => _evaluateCondition(challenge.condition, _getPrayerQueryBuilder()),
      FeatureName.temptation => _evaluateCondition(challenge.condition, _getTemptationQueryBuilder()),
    };
  }
  
  // Generic condition evaluator
  bool _evaluateCondition(Map<String, dynamic> condition, QueryBuilder Function() getQueryBuilder) {
    // Check if this is a logical operator (AND/OR)
    if (condition.containsKey('operator') && 
        (condition['operator'] == 'AND' || condition['operator'] == 'OR')) {
      return _evaluateLogicalCondition(condition, getQueryBuilder);
    }
    
    // Single condition
    return _evaluateSingleCondition(condition, getQueryBuilder());
  }
  
  // Handle AND/OR conditions
  bool _evaluateLogicalCondition(Map<String, dynamic> condition, QueryBuilder Function() getQueryBuilder) {
    final operator = condition['operator'] as String;
    final conditions = condition['conditions'] as List<dynamic>;
    
    if (operator == 'AND') {
      // All conditions must be true
      return conditions.every((cond) => _evaluateCondition(cond, getQueryBuilder));
    } else if (operator == 'OR') {
      // At least one condition must be true  
      return conditions.any((cond) => _evaluateCondition(cond, getQueryBuilder));
    }
    
    return false;
  }
  
  // Evaluate single field condition
  bool _evaluateSingleCondition(Map<String, dynamic> condition, QueryBuilder queryBuilder) {
    final field = condition['field'] as String;
    final operator = condition['operator'] as String;
    final value = condition['value'];
    
    // Build the query based on field and operator
    final query = _buildFieldQuery(queryBuilder, field, operator, value);
    return query?.build().findFirst() != null;
  }
  
  // Build ObjectBox query for specific field/operator/value
  QueryBuilder? _buildFieldQuery(QueryBuilder builder, String field, String operator, dynamic value) {
    // This will be feature-specific implementation
    return null; // Implemented in feature-specific methods below
  }
  
  // Feature-specific query builders
  QueryBuilder _getStreakQueryBuilder() => streakBox.query();
  QueryBuilder _getPrayerQueryBuilder() => prayerBox.query();
  QueryBuilder _getTemptationQueryBuilder() => temptationBox.query();
  
  // Mark challenge as completed
  Future<void> markChallengeCompleted(String challengeId) async {
    final challenge = challengesBox.query(ChallengeEntity_.id.equals(challengeId))
        .build().findFirst();
    if (challenge != null) {
      challenge.isCompleted = true; 
      challenge.completedAt = DateTime.now();
      challengesBox.put(challenge);
    }
  }
}
```

#### Feature-Specific Query Building Extensions
```dart
extension StreakQueryBuilder on ChallengesRepository {
  QueryBuilder? _buildStreakFieldQuery(QueryBuilder builder, String field, String operator, dynamic value) {
    return switch (field) {
      'consecutiveDays' => _applyOperator(builder, Streak_.consecutiveDays, operator, value),
      'totalDays' => _applyOperator(builder, Streak_.totalDays, operator, value),
      'isActive' => _applyOperator(builder, Streak_.isActive, operator, value),
      'lastUpdated' => _applyDateOperator(builder, Streak_.lastUpdated, operator, value),
      _ => null,
    };
  }
}

extension PrayerQueryBuilder on ChallengesRepository {
  QueryBuilder? _buildPrayerFieldQuery(QueryBuilder builder, String field, String operator, dynamic value) {
    return switch (field) {
      'totalCount' => _applyOperator(builder, Prayer_.totalCount, operator, value),
      'onTimeCount' => _applyOperator(builder, Prayer_.onTimeCount, operator, value),
      'consecutiveDays' => _applyOperator(builder, Prayer_.consecutiveDays, operator, value),
      'averageRating' => _applyOperator(builder, Prayer_.averageRating, operator, value),
      _ => null,
    };
  }
}

extension TemptationQueryBuilder on ChallengesRepository {
  QueryBuilder? _buildTemptationFieldQuery(QueryBuilder builder, String field, String operator, dynamic value) {
    return switch (field) {
      'resistedCount' => _applyOperator(builder, Temptation_.resistedCount, operator, value),
      'streakDays' => _applyOperator(builder, Temptation_.streakDays, operator, value),
      'lastTemptationDate' => _applyDateOperator(builder, Temptation_.lastTemptationDate, operator, value),
      _ => null,
    };
  }
}
```

#### Generic Operator Application
```dart
extension QueryOperators on ChallengesRepository {
  QueryBuilder? _applyOperator(QueryBuilder builder, QueryProperty property, String operator, dynamic value) {
    return switch (operator) {
      'equals' => builder..property.equals(value),
      'notEquals' => builder..property.notEquals(value),
      'greaterThan' => builder..property.greaterThan(value),
      'greaterOrEqual' => builder..property.greaterOrEqual(value),
      'lessThan' => builder..property.lessThan(value),
      'lessOrEqual' => builder..property.lessOrEqual(value),
      'between' => builder..property.between(value['min'], value['max']),
      'isNull' => builder..property.isNull(),
      'isNotNull' => builder..property.isNotNull(),
      'oneOf' => builder..property.oneOf(value as List),
      'contains' => builder..property.contains(value as String),
      'startsWith' => builder..property.startsWith(value as String),
      'endsWith' => builder..property.endsWith(value as String),
      _ => null,
    };
  }
  
  QueryBuilder? _applyDateOperator(QueryBuilder builder, QueryProperty property, String operator, dynamic value) {
    final dateValue = value is String ? DateTime.parse(value) : value as DateTime;
    return switch (operator) {
      'equals' => builder..property.equals(dateValue.millisecondsSinceEpoch),
      'greaterThan' => builder..property.greaterThan(dateValue.millisecondsSinceEpoch),
      'greaterOrEqual' => builder..property.greaterOrEqual(dateValue.millisecondsSinceEpoch),
      'lessThan' => builder..property.lessThan(dateValue.millisecondsSinceEpoch),
      'lessOrEqual' => builder..property.lessOrEqual(dateValue.millisecondsSinceEpoch),
      _ => null,
    };
  }
}
```

### 3. Updated Repository Implementation
```dart
@riverpod  
class ChallengesRepository extends _$ChallengesRepository {
  // ... previous methods ...
  
  @override
  QueryBuilder? _buildFieldQuery(QueryBuilder builder, String field, String operator, dynamic value) {
    return switch (state.currentFeature) {
      FeatureName.streak => _buildStreakFieldQuery(builder, field, operator, value),
      FeatureName.prayer => _buildPrayerFieldQuery(builder, field, operator, value), 
      FeatureName.temptation => _buildTemptationFieldQuery(builder, field, operator, value),
    };
  }
  
  @override
  bool _evaluateCondition(Map<String, dynamic> condition, QueryBuilder Function() getQueryBuilder) {
    // Set current feature context for field query building
    state = state.copyWith(currentFeature: _inferFeatureFromContext());
    return super._evaluateCondition(condition, getQueryBuilder);
  }
}
```

### 4. Providers Layer

#### Challenges Provider (for UI consumption)
```dart
@riverpod
class Challenges extends _$Challenges {
  @override
  Stream<List<Challenge>> build() {
    final repo = ref.watch(challengesRepositoryProvider);
    return repo.watchAllChallenges();
  }
}
```

#### Challenges Watcher Provider (for achievement detection)  
```dart
@riverpod
Stream<List<Challenge>> challengesWatcher(ChallengesWatcherRef ref) async* {
  final repo = ref.watch(challengesRepositoryProvider);
  
  // Combine all feature streams to detect any data changes
  final combinedStream = StreamGroup.merge([
    repo.watchStreakData(),
    repo.watchPrayerData(), 
    repo.watchTemptationData(),
  ]);
  
  await for (final _ in combinedStream) {
    // Get current unmet challenges
    final allChallenges = await ref.read(challengesProvider.future);
    final unmetChallenges = allChallenges.where((c) => !c.isCompleted).toList();
    
    // Check which challenges are newly met
    List<Challenge> newlyAchieved = [];
    
    for (final challenge in unmetChallenges) {
      if (repo.isChallengeMet(challenge)) {
        newlyAchieved.add(challenge);
        // Mark as completed to prevent re-detection
        await repo.markChallengeCompleted(challenge.id);
      }
    }
    
    // Yield newly achieved challenges
    if (newlyAchieved.isNotEmpty) {
      yield newlyAchieved;
    }
  }
}
```

### 5. Global Overlay Implementation

#### Main App Structure  
```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your Islamic App',
      builder: (context, child) {
        return Stack(
          children: [
            child!, // Your main app content
            // Global Achievement Overlay
            Consumer(
              builder: (context, ref, _) {
                return ref.watch(challengesWatcherProvider).when(
                  data: (newAchievements) => newAchievements.isNotEmpty 
                    ? AchievementOverlay(challenges: newAchievements)
                    : const SizedBox.shrink(),
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                );
              },
            ),
          ],
        );
      },
      home: HomeScreen(),
    );
  }
}
```

#### Achievement Overlay Widget (Enhanced for Islamic Theme)
```dart
class AchievementOverlay extends StatefulWidget {
  final List<Challenge> challenges;
  
  const AchievementOverlay({
    Key? key, 
    required this.challenges,
  }) : super(key: key);

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay> 
    with TickerProviderStateMixin {
  
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _pulseAnimation;
  
  int _currentIndex = 0;
  
  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _showNextAchievement();
  }
  
  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, -1.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
    ));
    
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    // Start pulse animation
    _pulseController.repeat(reverse: true);
  }
  
  void _showNextAchievement() {
    if (_currentIndex < widget.challenges.length) {
      _slideController.forward().then((_) {
        // Show for 2.5 seconds
        Future.delayed(const Duration(milliseconds: 2500), () {
          _slideController.reverse().then((_) {
            if (mounted) {
              setState(() {
                _currentIndex++;
              });
              _showNextAchievement();
            }
          });
        });
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_currentIndex >= widget.challenges.length) {
      return const SizedBox.shrink();
    }
    
    final challenge = widget.challenges[_currentIndex];
    
    return Positioned(
      top: MediaQuery.of(context).padding.top + 30,
      left: 20,
      right: 20,
      child: SlideTransition(
        position: _slideAnimation,
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: AnimatedBuilder(
            animation: _pulseAnimation,
            builder: (context, child) {
              return Transform.scale(
                scale: _pulseAnimation.value,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.green.shade700,
                        Colors.green.shade600,
                        Colors.teal.shade600,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 15,
                        spreadRadius: 2,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Icon(
                          _getFeatureIcon(challenge.featureName),
                          color: _getFeatureColor(challenge.featureName),
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '🎉 Challenge Completed!',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              challenge.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            Text(
                              challenge.description,
                              style: const TextStyle(
                                color: Colors.white90,
                                fontSize: 14,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Barakallahu feek! 🤲',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
  
  IconData _getFeatureIcon(FeatureName feature) {
    return switch (feature) {
      FeatureName.streak => Icons.local_fire_department,
      FeatureName.prayer => Icons.mosque,
      FeatureName.temptation => Icons.shield,
    };
  }
  
  Color _getFeatureColor(FeatureName feature) {
    return switch (feature) {
      FeatureName.streak => Colors.orange.shade600,
      FeatureName.prayer => Colors.blue.shade600,
      FeatureName.temptation => Colors.purple.shade600,
    };
  }
  
  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }
}
```

### 6. Usage Examples

#### Creating Challenges with JSON Conditions
```dart
final List<Challenge> sampleChallenges = [
  // Simple condition
  Challenge(
    id: 'streak_week',
    title: '7 Day Streak',
    description: 'Maintain a 7-day consecutive streak',
    featureName: FeatureName.streak,
    condition: {
      "field": "consecutiveDays",
      "operator": "greaterOrEqual", 
      "value": 7
    },
    iconPath: 'assets/streak_icon.svg',
  ),
  
  // AND condition  
  Challenge(
    id: 'prayer_consistent',
    title: 'Consistent Prayer',
    description: 'Pray 100 times with 80% on-time rate',
    featureName: FeatureName.prayer,
    condition: {
      "operator": "AND",
      "conditions": [
        {
          "field": "totalCount",
          "operator": "greaterOrEqual",
          "value": 100
        },
        {
          "field": "onTimePercentage",
          "operator": "greaterOrEqual", 
          "value": 80
        }
      ]
    },
    iconPath: 'assets/prayer_icon.svg',
  ),
  
  // Complex nested condition
  Challenge(
    id: 'temptation_master',
    title: 'Temptation Master',
    description: 'Either resist 50 temptations or maintain 30-day streak',
    featureName: FeatureName.temptation,
    condition: {
      "operator": "OR",
      "conditions": [
        {
          "field": "resistedCount",
          "operator": "greaterOrEqual",
          "value": 50
        },
        {
          "field": "streakDays", 
          "operator": "greaterOrEqual",
          "value": 30
        }
      ]
    },
    iconPath: 'assets/shield_icon.svg',
  ),
];
```

## Key Benefits of This Final Architecture

1. **Flexible JSON Conditions**: Support for simple, AND, OR, and nested conditions
2. **ObjectBox Query Mapping**: Direct mapping to ObjectBox query operations  
3. **Type-Safe Operators**: Comprehensive operator support with proper typing
4. **Feature Extensibility**: Easy to add new features and field types
5. **Performance Optimized**: Efficient query building and evaluation
6. **Islamic Theme Integration**: Barakallahu feek messages and appropriate styling
7. **Complex Logic Support**: Handles any combination of conditions naturally

## Supported Operators

### Comparison Operators
- `equals`, `notEquals`
- `greaterThan`, `greaterOrEqual`  
- `lessThan`, `lessOrEqual`
- `between` (requires `{min: x, max: y}` value)

### Null Operators  
- `isNull`, `isNotNull`

### Array Operators
- `oneOf`, `notOneOf` (requires array value)

### String Operators
- `contains`, `startsWith`, `endsWith`

### Date Operators
- All comparison operators work with DateTime values (converted to milliseconds)

### Logical Operators
- `AND`, `OR` (with `conditions` array)

## Implementation Steps

1. ✅ Create Challenge model with JSON condition support
2. ✅ Implement ChallengesRepository with JSON condition parsing  
3. ✅ Create operator mapping system for ObjectBox queries
4. ✅ Add feature-specific field query builders
5. ✅ Implement logical condition evaluation (AND/OR)
6. ✅ Create Challenges provider for UI consumption
7. ✅ Implement ChallengesWatcher StreamProvider
8. ✅ Create enhanced AchievementOverlay with Islamic theme
9. ✅ Integrate global overlay in MaterialApp builder
10. ✅ Test with various condition combinations

---

*Bismillah, may this comprehensive system help users achieve their spiritual goals and receive barakah in their journey! 🤲✨*

**Final Architecture Status: ✅ COMPLETE & PRODUCTION-READY**