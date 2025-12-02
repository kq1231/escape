import 'package:flutter/material.dart';

import '../constants/onboarding_constants.dart';
import '../models/onboarding_data.dart';
import '../molecules/custom_input_selector.dart';
import '../templates/onboarding_page_template.dart';

class TriggersScreen extends StatefulWidget {
  final OnboardingData data;
  final Function(OnboardingData) onNext;
  final VoidCallback onBack;

  const TriggersScreen({super.key, required this.data, required this.onNext, required this.onBack});

  @override
  State<TriggersScreen> createState() => _TriggersScreenState();
}

class _TriggersScreenState extends State<TriggersScreen> {
  late List<String> _selectedTriggers;
  late List<String> _customTriggers;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _selectedTriggers = List.from(widget.data.selectedTriggers);
    _customTriggers = List.from(widget.data.customTriggers);
  }

  void _handleSelectedChanged(List<String> selected) {
    setState(() {
      _selectedTriggers = selected;
      _showError = false;
    });
  }

  void _handleCustomChanged(List<String> custom) {
    setState(() {
      _customTriggers = custom;
      _showError = false;
    });
  }

  void _handleNext() {
    if (_selectedTriggers.isEmpty && _customTriggers.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    // Update the parent with the selected triggers
    final updatedData = widget.data.copyWith(selectedTriggers: _selectedTriggers, customTriggers: _customTriggers);
    widget.onNext(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: '',
      currentStep: 5,
      totalSteps: 7,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Continue',
      isNextEnabled: _selectedTriggers.isNotEmpty || _customTriggers.isNotEmpty,
      child: CustomInputSelector(
        title: OnboardingConstants.triggersTitle,
        subtitle: OnboardingConstants.triggersSubtitle,
        predefinedItems: OnboardingConstants.triggers,
        selectedItems: _selectedTriggers,
        customItems: _customTriggers,
        onSelectedChanged: _handleSelectedChanged,
        onCustomChanged: _handleCustomChanged,
        hintText: 'Enter your custom trigger...',
        addButtonText: 'Add Trigger',
        showError: _showError,
      ),
    );
  }
}
