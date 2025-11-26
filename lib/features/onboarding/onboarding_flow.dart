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
  late OnboardingData _data;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _data = widget.initialData ?? const OnboardingData();
  }

  void _handleNext() async {
    if (_currentPage < 6) {
      setState(() {
        _currentPage++;
      });
    } else {
      await _saveUserProfile();
      if (!mounted) return;
      widget.onComplete?.call(context);
    }
  }

  void _handleBack() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _saveUserProfile() async {
    final profile = user_profile.UserProfile(
      name: _data.name,
      goals: _data.allGoals,
      hobbies: _data.allHobbies,
      triggers: _data.allTriggers,
      streakGoal: 1,
      passwordHash: _hashPassword(_data.password),
      biometricEnabled: _data.biometricEnabled,
      notificationsEnabled: _data.notificationsEnabled,
      profilePicture: _data.profilePicture,
    );

    await ref.read(userProfileProvider.notifier).saveProfile(profile);
  }

  String _hashPassword(String password) {
    final salt = 'escape_app_salt';
    final combined = '$password$salt';
    final bytes = utf8.encode(combined);
    final hash = bytes.fold<int>(0, (prev, element) => prev + element);
    return hash.toString();
  }

  Widget _buildPage(int index) {
    switch (index) {
      case 0:
        return WelcomeScreen(onNext: _handleNext);
      case 1:
        return NameScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      case 2:
        return ProfileImageScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      case 3:
        return GoalsScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      case 4:
        return HobbiesScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      case 5:
        return TriggersScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      case 6:
        return SecurityScreen(
          data: _data,
          onNext: (updatedData) {
            setState(() => _data = updatedData);
            _handleNext();
          },
          onBack: _handleBack,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // ✨ FadeTransition between pages
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 600),
        switchInCurve: Curves.easeInOut,
        switchOutCurve: Curves.easeInOut,
        transitionBuilder: (Widget child, Animation<double> animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: _buildPage(_currentPage),
      ),
    );
  }
}
