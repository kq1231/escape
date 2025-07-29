import 'package:objectbox/objectbox.dart';

@Entity()
class Streak {
  @Id()
  int id = 0;

  // Total streak count
  int count;

  // Streak goal
  int goal;

  // Mood tracking (1-10 scale)
  int mood;

  // Date of the streak record
  @Property(type: PropertyType.date)
  DateTime date;

  // Constructor
  Streak({
    this.id = 0,
    this.count = 0,
    this.goal = 30, // Default goal of 30 days
    this.mood = 5, // Default neutral mood
    DateTime? date,
  }) : date = date ?? DateTime.now();

  // Copy with method for immutability
  Streak copyWith({int? id, int? count, int? goal, int? mood, DateTime? date}) {
    return Streak(
      id: id ?? this.id,
      count: count ?? this.count,
      goal: goal ?? this.goal,
      mood: mood ?? this.mood,
      date: date ?? this.date,
    );
  }

  // Check if streak was successful (met goal)
  bool get isGoalAchieved => count >= goal;

  // Progress percentage to goal
  double get progressPercentage => goal > 0 ? (count / goal) * 100 : 0;

  @override
  String toString() {
    return 'Streak(id: $id, count: $count, goal: $goal, mood: $mood, date: $date)';
  }
}
