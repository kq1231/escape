import 'package:objectbox/objectbox.dart';
import 'xp_history_item_model.dart';

@Entity()
class Temptation {
  @Id()
  int id = 0;

  @Property(type: PropertyType.date)
  DateTime createdAt;

  @Property(type: PropertyType.date)
  DateTime? resolvedAt;

  // User tracking
  List<String> triggers = [];
  List<String> helpfulActivities = [];
  String? selectedActivity;

  // Outcome tracking
  bool wasSuccessful; // true = overcame, false = relapsed
  String? resolutionNotes;

  // Emotional state
  int? intensityBefore; // 1-10 scale
  int? intensityAfter; // 1-10 scale

  // Relation to XP history item
  final xpHistory = ToOne<XPHistoryItem>();

  Temptation({
    required this.createdAt,
    this.wasSuccessful = false,
    this.intensityBefore,
    this.intensityAfter,
    this.resolutionNotes,
    this.selectedActivity,
    this.triggers = const [],
    this.helpfulActivities = const [],
  });

  // Copy with method for immutability
  Temptation copyWith({
    int? id,
    DateTime? createdAt,
    List<String>? triggers,
    List<String>? helpfulActivities,
    String? selectedActivity,
    bool? wasSuccessful,
    String? resolutionNotes,
  }) {
    return Temptation(
        createdAt: createdAt ?? this.createdAt,
        wasSuccessful: wasSuccessful ?? this.wasSuccessful,
        resolutionNotes: resolutionNotes ?? this.resolutionNotes,
      )
      ..id = id ?? this.id
      ..triggers = triggers ?? this.triggers
      ..helpfulActivities = helpfulActivities ?? this.helpfulActivities
      ..selectedActivity = selectedActivity ?? this.selectedActivity;
  }

  // Get duration of temptation
  Duration? get duration {
    if (resolvedAt == null) return null;
    return resolvedAt!.difference(createdAt);
  }

  @override
  String toString() {
    return 'Temptation(id: $id, createdAt: $createdAt, resolvedAt: $resolvedAt, '
        'wasSuccessful: $wasSuccessful, triggers: $triggers, '
        'helpfulActivities: $helpfulActivities, selectedActivity: $selectedActivity, '
        'intensityBefore: $intensityBefore, intensityAfter: $intensityAfter)';
  }
}
