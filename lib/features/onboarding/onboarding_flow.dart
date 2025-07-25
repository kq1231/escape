import 'package:flutter/material.dart';
import 'models/onboarding_data.dart';
import 'screens/goals_screen.dart';
import 'screens/hobbies_screen.dart';
import 'screens/security_screen.dart';
import 'screens/triggers_screen.dart';
import 'screens/welcome_screen.dart';
import 'services/storage_service.dart';

class OnboardingFlow extends StatefulWidget {
  final VoidCallback onComplete;
  final OnboardingData? initialData;

  const OnboardingFlow({super.key, required this.onComplete, this.initialData});

  @override
  State<OnboardingFlow> createState() => _OnboardingFlowState();
}

class _OnboardingFlowState extends State<OnboardingFlow> {
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

  void _handleNext() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Save the hashed password before completing onboarding
      if (_data.password.isNotEmpty) {
        StorageService.savePassword(_data.password);
      }
      widget.onComplete();
    }
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
    _data = _data.copyWith(
      selectedGoals: selectedGoals,
      customGoals: customGoals,
      selectedHobbies: selectedHobbies,
      customHobbies: customHobbies,
      selectedTriggers: selectedTriggers,
      customTriggers: customTriggers,
      password: password,
      biometricEnabled: biometricEnabled,
      notificationsEnabled: notificationsEnabled,
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
