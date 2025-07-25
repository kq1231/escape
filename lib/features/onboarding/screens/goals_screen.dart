import 'package:flutter/material.dart';
import '../molecules/custom_input_selector.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';
import '../constants/onboarding_constants.dart';

class GoalsScreen extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const GoalsScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<GoalsScreen> createState() => _GoalsScreenState();
}

class _GoalsScreenState extends State<GoalsScreen> {
  late List<String> _selectedGoals;
  late List<String> _customGoals;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _selectedGoals = List.from(widget.data.selectedGoals);
    _customGoals = List.from(widget.data.customGoals);
  }

  void _handleSelectedChanged(List<String> selected) {
    setState(() {
      _selectedGoals = selected;
      _showError = false;
    });
  }

  void _handleCustomChanged(List<String> custom) {
    setState(() {
      _customGoals = custom;
      _showError = false;
    });
  }

  void _handleNext() {
    if (_selectedGoals.isEmpty && _customGoals.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }
    widget.onNext();
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: '',
      currentStep: 2,
      totalSteps: 5,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Continue',
      isNextEnabled: _selectedGoals.isNotEmpty || _customGoals.isNotEmpty,
      child: CustomInputSelector(
        title: OnboardingConstants.goalsTitle,
        subtitle: OnboardingConstants.goalsSubtitle,
        predefinedItems: OnboardingConstants.goals,
        selectedItems: _selectedGoals,
        customItems: _customGoals,
        onSelectedChanged: _handleSelectedChanged,
        onCustomChanged: _handleCustomChanged,
        hintText: 'Enter your custom goal...',
        addButtonText: 'Add Goal',
        showError: _showError,
      ),
    );
  }
}
