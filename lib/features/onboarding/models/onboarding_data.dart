import 'package:flutter/foundation.dart';

class OnboardingData {
  final String name;
  final List<String> selectedGoals;
  final List<String> customGoals;
  final List<String> selectedHobbies;
  final List<String> customHobbies;
  final List<String> selectedTriggers;
  final List<String> customTriggers;
  final String password;
  final bool biometricEnabled;
  final bool notificationsEnabled;
  final String profilePicture;

  const OnboardingData({
    this.name = '',
    this.selectedGoals = const [],
    this.customGoals = const [],
    this.selectedHobbies = const [],
    this.customHobbies = const [],
    this.selectedTriggers = const [],
    this.customTriggers = const [],
    this.password = '',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
    this.profilePicture = '',
  });

  OnboardingData copyWith({
    String? name,
    List<String>? selectedGoals,
    List<String>? customGoals,
    List<String>? selectedHobbies,
    List<String>? customHobbies,
    List<String>? selectedTriggers,
    List<String>? customTriggers,
    String? password,
    bool? biometricEnabled,
    bool? notificationsEnabled,
    String? profilePicture,
  }) {
    return OnboardingData(
      name: name ?? this.name,
      selectedGoals: selectedGoals ?? this.selectedGoals,
      customGoals: customGoals ?? this.customGoals,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
      customHobbies: customHobbies ?? this.customHobbies,
      selectedTriggers: selectedTriggers ?? this.selectedTriggers,
      customTriggers: customTriggers ?? this.customTriggers,
      password: password ?? this.password,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      profilePicture: profilePicture ?? this.profilePicture,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'selectedGoals': selectedGoals,
      'customGoals': customGoals,
      'selectedHobbies': selectedHobbies,
      'customHobbies': customHobbies,
      'selectedTriggers': selectedTriggers,
      'customTriggers': customTriggers,
      'password': password,
      'biometricEnabled': biometricEnabled,
      'notificationsEnabled': notificationsEnabled,
      'profilePicture': profilePicture,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      name: json['name'] ?? '',
      selectedGoals: List<String>.from(json['selectedGoals'] ?? []),
      customGoals: List<String>.from(json['customGoals'] ?? []),
      selectedHobbies: List<String>.from(json['selectedHobbies'] ?? []),
      customHobbies: List<String>.from(json['customHobbies'] ?? []),
      selectedTriggers: List<String>.from(json['selectedTriggers'] ?? []),
      customTriggers: List<String>.from(json['customTriggers'] ?? []),
      password: json['password'] ?? '',
      biometricEnabled: json['biometricEnabled'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingData &&
        other.name == name &&
        listEquals(other.selectedGoals, selectedGoals) &&
        listEquals(other.customGoals, customGoals) &&
        listEquals(other.selectedHobbies, selectedHobbies) &&
        listEquals(other.customHobbies, customHobbies) &&
        listEquals(other.selectedTriggers, selectedTriggers) &&
        listEquals(other.customTriggers, customTriggers) &&
        other.password == password &&
        other.biometricEnabled == biometricEnabled &&
        other.notificationsEnabled == notificationsEnabled &&
        other.profilePicture == profilePicture;
  }

  @override
  int get hashCode {
    return Object.hash(
      name,
      selectedGoals,
      customGoals,
      selectedHobbies,
      customHobbies,
      selectedTriggers,
      customTriggers,
      password,
      biometricEnabled,
      notificationsEnabled,
      profilePicture,
    );
  }

  bool get isComplete {
    return name.isNotEmpty &&
        (selectedGoals.isNotEmpty || customGoals.isNotEmpty) &&
        (selectedHobbies.isNotEmpty || customHobbies.isNotEmpty) &&
        (selectedTriggers.isNotEmpty || customTriggers.isNotEmpty) &&
        password.isNotEmpty;
  }

  List<String> get allGoals => [...selectedGoals, ...customGoals];
  List<String> get allHobbies => [...selectedHobbies, ...customHobbies];
  List<String> get allTriggers => [...selectedTriggers, ...customTriggers];
}
