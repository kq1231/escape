import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'models/onboarding_data.dart';
import 'screens/goals_screen.dart';
import 'screens/hobbies_screen.dart';
import 'screens/security_screen.dart';
import 'screens/triggers_screen.dart';
import 'screens/welcome_screen.dart';
import 'screens/name_screen.dart';
import 'screens/profile_image_screen.dart';
import '../../providers/user_profile_provider.dart';
import '../../models/user_profile_model.dart' as user_profile;

class OnboardingFlow extends ConsumerStatefulWidget {
  final Function(BuildContext context)? onComplete;
  final OnboardingData? initialData;

  const OnboardingFlow({super.key, this.onComplete, this.initialData});

  @override
  ConsumerState<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends ConsumerState<OnboardingFlow> {
  late PageController _pageController;
  late OnboardingData _data;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _data = widget.initialData ?? const OnboardingData();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleNext() async {
    if (_currentPage < 6) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save the user profile instead of using shared preferences
      await _saveUserProfile();

      if (!mounted) return;
      widget.onComplete?.call(context);
    }
  }

  Future<void> _saveUserProfile() async {
    // Create a user profile from the onboarding data
    final profile = user_profile.UserProfile(
      name: _data.name,
      goals: _data.allGoals,
      hobbies: _data.allHobbies,
      triggers: _data.allTriggers,
      streakGoal: 1, // Default streak goal
      passwordHash: _hashPassword(_data.password), // Hash the password
      biometricEnabled: _data.biometricEnabled,
      notificationsEnabled: _data.notificationsEnabled,
      profilePicture: _data.profilePicture,
    );

    // Save the user profile
    await ref.read(userProfileProvider.notifier).saveProfile(profile);
  }

  String _hashPassword(String password) {
    // Simple hash function for demonstration purposes only
    // In a real application, you would use a proper cryptographic hash function
    final salt = 'escape_app_salt';
    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final hash = bytes.fold<int>(0, (prev, element) => prev + element);
    return hash.toString();
  }

  void _handleBack() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _handlePageChanged(int page) {
    setState(() {
      _currentPage = page;
    });
  }

  OnboardingData _updateData({
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
    _data = _data.copyWith(
      name: name ?? _data.name,
      selectedGoals: selectedGoals ?? _data.selectedGoals,
      customGoals: customGoals ?? _data.customGoals,
      selectedHobbies: selectedHobbies ?? _data.selectedHobbies,
      customHobbies: customHobbies ?? _data.customHobbies,
      selectedTriggers: selectedTriggers ?? _data.selectedTriggers,
      customTriggers: customTriggers ?? _data.customTriggers,
      password: password ?? _data.password,
      biometricEnabled: biometricEnabled ?? _data.biometricEnabled,
      notificationsEnabled: notificationsEnabled ?? _data.notificationsEnabled,
      profilePicture: profilePicture ?? _data.profilePicture,
    );
    return _data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: _pageController,
        onPageChanged: _handlePageChanged,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          WelcomeScreen(onNext: _handleNext),
          NameScreen(
            data: _data,
            onNext: (updatedData) {
              setState(() {
                _data = updatedData;
              });
              _handleNext();
            },
            onBack: _handleBack,
          ),
          ProfileImageScreen(
            data: _data,
            onNext: (updatedData) {
              setState(() {
                _data = updatedData;
              });
              _handleNext();
            },
            onBack: _handleBack,
          ),
          GoalsScreen(
            data: _data,
            onNext: () {
              _updateData(
                selectedGoals: _data.selectedGoals,
                customGoals: _data.customGoals,
              );
              _handleNext();
            },
            onBack: _handleBack,
          ),
          HobbiesScreen(
            data: _data,
            onNext: () {
              _updateData(
                selectedHobbies: _data.selectedHobbies,
                customHobbies: _data.customHobbies,
              );
              _handleNext();
            },
            onBack: _handleBack,
          ),
          TriggersScreen(
            data: _data,
            onNext: () {
              _updateData(
                selectedTriggers: _data.selectedTriggers,
                customTriggers: _data.customTriggers,
              );
              _handleNext();
            },
            onBack: _handleBack,
          ),
          SecurityScreen(
            data: _data,
            onNext: () {
              _handleNext();
            },
            onBack: _handleBack,
          ),
        ],
      ),
    );
  }
}
