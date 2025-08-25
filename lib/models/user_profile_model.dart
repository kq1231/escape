import 'package:objectbox/objectbox.dart';

@Entity()
class UserProfile {
  @Id(assignable: true)
  int id = 1; // Always 1 for single user profile

  // User's name
  String name;

  // User's goals
  List<String> goals;

  // User's hobbies
  List<String> hobbies;

  // User's triggers
  List<String> triggers;

  // Streak goal
  int streakGoal;

  // Password hash
  String passwordHash;

  // Biometric authentication enabled
  bool biometricEnabled;

  // Notifications enabled
  bool notificationsEnabled;

  // Profile picture path/URL (relative path)
  String profilePicture;

  // Total experience points
  int xp = 0;

  // Getter to get the full path of the profile picture
  String get fullProfilePicturePath {
    if (profilePicture.isEmpty) return '';
    // This getter should be used in async context to get the full path
    // For now, we'll return the relative path and let the UI handle the full path resolution
    return profilePicture;
  }

  // Creation timestamp
  @Property(type: PropertyType.date)
  DateTime createdAt;

  // Last updated timestamp
  @Property(type: PropertyType.date)
  DateTime lastUpdated;

  // Constructor
  UserProfile({
    this.id = 1,
    this.name = '',
    List<String>? goals,
    List<String>? hobbies,
    List<String>? triggers,
    this.streakGoal = 1,
    this.passwordHash = '',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
    this.profilePicture = '',
    this.xp = 0,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) : goals = goals ?? [],
       hobbies = hobbies ?? [],
       triggers = triggers ?? [],
       createdAt = createdAt ?? DateTime.now(),
       lastUpdated = lastUpdated ?? DateTime.now();

  // Copy with method for immutability
  UserProfile copyWith({
    int? id,
    String? name,
    List<String>? goals,
    List<String>? hobbies,
    List<String>? triggers,
    int? streakGoal,
    String? passwordHash,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    String? profilePicture,
    int? xp,
    DateTime? createdAt,
    DateTime? lastUpdated,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      goals: goals ?? this.goals,
      hobbies: hobbies ?? this.hobbies,
      triggers: triggers ?? this.triggers,
      streakGoal: streakGoal ?? this.streakGoal,
      passwordHash: passwordHash ?? this.passwordHash,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      profilePicture: profilePicture ?? this.profilePicture,
      xp: xp ?? this.xp,
      createdAt: createdAt ?? this.createdAt,
      lastUpdated: lastUpdated ?? DateTime.now(),
    );
  }

  // Check if profile is complete (has essential data)
  bool get isComplete {
    return name.isNotEmpty &&
        goals.isNotEmpty &&
        hobbies.isNotEmpty &&
        triggers.isNotEmpty &&
        passwordHash.isNotEmpty;
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, goals: $goals, hobbies: $hobbies, triggers: $triggers, streakGoal: $streakGoal, passwordHash: $passwordHash, biometricEnabled: $biometricEnabled, notificationsEnabled: $notificationsEnabled, profilePicture: $profilePicture, xp: $xp, createdAt: $createdAt, lastUpdated: $lastUpdated)';
  }
}
