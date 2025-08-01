import 'package:flutter/foundation.dart';

class OnboardingData {
  final List<String> selectedGoals;
  final List<String> customGoals;
  final List<String> selectedHobbies;
  final List<String> customHobbies;
  final List<String> selectedTriggers;
  final List<String> customTriggers;
  final String password;
  final bool biometricEnabled;
  final bool notificationsEnabled;

  const OnboardingData({
    this.selectedGoals = const [],
    this.customGoals = const [],
    this.selectedHobbies = const [],
    this.customHobbies = const [],
    this.selectedTriggers = const [],
    this.customTriggers = const [],
    this.password = '',
    this.biometricEnabled = false,
    this.notificationsEnabled = true,
  });

  OnboardingData copyWith({
    List<String>? selectedGoals,
    List<String>? customGoals,
    List<String>? selectedHobbies,
    List<String>? customHobbies,
    List<String>? selectedTriggers,
    List<String>? customTriggers,
    String? password,
    bool? biometricEnabled,
    bool? notificationsEnabled,
  }) {
    return OnboardingData(
      selectedGoals: selectedGoals ?? this.selectedGoals,
      customGoals: customGoals ?? this.customGoals,
      selectedHobbies: selectedHobbies ?? this.selectedHobbies,
      customHobbies: customHobbies ?? this.customHobbies,
      selectedTriggers: selectedTriggers ?? this.selectedTriggers,
      customTriggers: customTriggers ?? this.customTriggers,
      password: password ?? this.password,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'selectedGoals': selectedGoals,
      'customGoals': customGoals,
      'selectedHobbies': selectedHobbies,
      'customHobbies': customHobbies,
      'selectedTriggers': selectedTriggers,
      'customTriggers': customTriggers,
      'password': password,
      'biometricEnabled': biometricEnabled,
      'notificationsEnabled': notificationsEnabled,
    };
  }

  factory OnboardingData.fromJson(Map<String, dynamic> json) {
    return OnboardingData(
      selectedGoals: List<String>.from(json['selectedGoals'] ?? []),
      customGoals: List<String>.from(json['customGoals'] ?? []),
      selectedHobbies: List<String>.from(json['selectedHobbies'] ?? []),
      customHobbies: List<String>.from(json['customHobbies'] ?? []),
      selectedTriggers: List<String>.from(json['selectedTriggers'] ?? []),
      customTriggers: List<String>.from(json['customTriggers'] ?? []),
      password: json['password'] ?? '',
      biometricEnabled: json['biometricEnabled'] ?? false,
      notificationsEnabled: json['notificationsEnabled'] ?? true,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is OnboardingData &&
        listEquals(other.selectedGoals, selectedGoals) &&
        listEquals(other.customGoals, customGoals) &&
        listEquals(other.selectedHobbies, selectedHobbies) &&
        listEquals(other.customHobbies, customHobbies) &&
        listEquals(other.selectedTriggers, selectedTriggers) &&
        listEquals(other.customTriggers, customTriggers) &&
        other.password == password &&
        other.biometricEnabled == biometricEnabled &&
        other.notificationsEnabled == notificationsEnabled;
  }

  @override
  int get hashCode {
    return Object.hash(
      selectedGoals,
      customGoals,
      selectedHobbies,
      customHobbies,
      selectedTriggers,
      customTriggers,
      password,
      biometricEnabled,
      notificationsEnabled,
    );
  }

  bool get isComplete {
    return (selectedGoals.isNotEmpty || customGoals.isNotEmpty) &&
        (selectedHobbies.isNotEmpty || customHobbies.isNotEmpty) &&
        (selectedTriggers.isNotEmpty || customTriggers.isNotEmpty) &&
        password.isNotEmpty;
  }

  List<String> get allGoals => [...selectedGoals, ...customGoals];
  List<String> get allHobbies => [...selectedHobbies, ...customHobbies];
  List<String> get allTriggers => [...selectedTriggers, ...customTriggers];
}
