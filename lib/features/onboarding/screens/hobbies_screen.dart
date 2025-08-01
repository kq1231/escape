import 'package:flutter/material.dart';
import '../molecules/custom_input_selector.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';
import '../constants/onboarding_constants.dart';

class HobbiesScreen extends StatefulWidget {
  final OnboardingData data;
  final VoidCallback onNext;
  final VoidCallback onBack;

  const HobbiesScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<HobbiesScreen> createState() => _HobbiesScreenState();
}

class _HobbiesScreenState extends State<HobbiesScreen> {
  late List<String> _selectedHobbies;
  late List<String> _customHobbies;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _selectedHobbies = List.from(widget.data.selectedHobbies);
    _customHobbies = List.from(widget.data.customHobbies);
  }

  void _handleSelectedChanged(List<String> selected) {
    setState(() {
      _selectedHobbies = selected;
      _showError = false;
    });
  }

  void _handleCustomChanged(List<String> custom) {
    setState(() {
      _customHobbies = custom;
      _showError = false;
    });
  }

  void _handleNext() {
    if (_selectedHobbies.isEmpty && _customHobbies.isEmpty) {
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
      currentStep: 3,
      totalSteps: 5,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Continue',
      isNextEnabled: _selectedHobbies.isNotEmpty || _customHobbies.isNotEmpty,
      child: CustomInputSelector(
        title: OnboardingConstants.hobbiesTitle,
        subtitle: OnboardingConstants.hobbiesSubtitle,
        predefinedItems: OnboardingConstants.hobbies,
        selectedItems: _selectedHobbies,
        customItems: _customHobbies,
        onSelectedChanged: _handleSelectedChanged,
        onCustomChanged: _handleCustomChanged,
        hintText: 'Enter your custom hobby...',
        addButtonText: 'Add Hobby',
        showError: _showError,
      ),
    );
  }
}
