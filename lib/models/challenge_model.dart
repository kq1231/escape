import 'dart:convert';
import 'package:objectbox/objectbox.dart';
import 'xp_history_item_model.dart';

@Entity()
class Challenge {
  @Id()
  int id = 0;

  // Challenge details
  String title;
  String description;

  // Feature type this challenge belongs to (string instead of enum)
  String featureName;

  // JSON query condition for challenge completion
  String conditionJson;

  // Icon path for the challenge
  String iconPath;

  // Challenge completion status
  bool isCompleted;

  // When the challenge was completed
  @Property(type: PropertyType.date)
  DateTime? completedAt;

  // XP points for completing this challenge
  int xp;

  // Relation to XP history item
  final xpHistory = ToOne<XPHistoryItem>();

  Challenge({
    this.id = 0,
    required this.title,
    required this.description,
    required this.featureName,
    required this.conditionJson,
    required this.iconPath,
    this.isCompleted = false,
    this.completedAt,
    this.xp = 0,
  });

  // Factory constructor from JSON
  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      featureName: json['featureName'] ?? '',
      conditionJson: jsonEncode(json['condition'] ?? {}),
      iconPath: json['iconPath'] ?? '',
      isCompleted: json['isCompleted'] ?? false,
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'])
          : null,
      xp: json['xp'] ?? 0,
    );
  }

  // Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'featureName': featureName,
      'condition': jsonDecode(conditionJson),
      'iconPath': iconPath,
      'isCompleted': isCompleted,
      'completedAt': completedAt?.toIso8601String(),
      'xp': xp,
    };
  }

  // Copy with method for immutability
  Challenge copyWith({
    int? id,
    String? title,
    String? description,
    String? featureName,
    String? conditionJson,
    String? iconPath,
    bool? isCompleted,
    DateTime? completedAt,
    int? xp,
  }) {
    return Challenge(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      featureName: featureName ?? this.featureName,
      conditionJson: conditionJson ?? this.conditionJson,
      iconPath: iconPath ?? this.iconPath,
      isCompleted: isCompleted ?? this.isCompleted,
      completedAt: completedAt ?? this.completedAt,
      xp: xp ?? this.xp,
    );
  }

  @override
  String toString() {
    return 'Challenge(id: $id, title: $title, description: $description, '
        'featureName: $featureName, condition: $conditionJson, iconPath: $iconPath, '
        'isCompleted: $isCompleted, completedAt: $completedAt, xp: $xp)';
  }
}
