import 'package:objectbox/objectbox.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  // Total streak count
  int count;

  // Streak goal (default: 1 day for new users)
  int goal;

  // Mood tracking - emotion type (happy, sad, anxious, grateful, angry, neutral)
  String emotion;

  // Mood intensity (1-10 scale)
  int moodIntensity;

  // Date of the streak record
  @Property(type: PropertyType.date)
  DateTime date;

  // Creation timestamp
  @Property(type: PropertyType.date)
  DateTime createdAt;

  // Last updated timestamp
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  // Success flag - true means success, false means relapse
  bool isSuccess;

  // Constructor
  Streak({
    this.id = 0,
    this.count = 0,
    this.goal = 1, // Default goal of 1 day for new users
    this.emotion = 'neutral', // Default emotion
    this.moodIntensity = 0, // Default zero intensity
    this.isSuccess = true, // Default to success
    DateTime? date,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) : date = date ?? DateTime.now(),
       createdAt = createdAt ?? DateTime.now(),
       lastUpdated = lastUpdated ?? DateTime.now();

  // Copy with method for immutability
  Streak copyWith({
    int? id,
    int? count,
    int? goal,
    String? emotion,
    int? moodIntensity,
    bool? isSuccess,
    DateTime? date,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return Streak(
      id: id ?? this.id,
      count: count ?? this.count,
      goal: goal ?? this.goal,
      emotion: emotion ?? this.emotion,
      moodIntensity: moodIntensity ?? this.moodIntensity,
      isSuccess: isSuccess ?? this.isSuccess,
      date: date ?? this.date,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // Check if streak was successful (met goal)
  bool get isGoalAchieved => count >= goal;

  // Progress percentage to goal
  double get progressPercentage => goal > 0 ? (count / goal) * 100 : 0;

  @override
  String toString() {
    return 'Streak(id: $id, count: $count, goal: $goal, emotion: $emotion, moodIntensity: $moodIntensity, isSuccess: $isSuccess, date: $date, createdAt: $createdAt, lastUpdated: $lastUpdated)';
  }
}
