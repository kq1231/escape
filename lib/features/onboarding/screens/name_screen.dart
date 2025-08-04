import 'package:flutter/material.dart';
import '../atoms/input_field.dart';
import '../models/onboarding_data.dart';
import '../templates/onboarding_page_template.dart';
import 'package:escape/theme/app_theme.dart';

class NameScreen extends StatefulWidget {
  final OnboardingData data;
  final Function(OnboardingData) onNext;
  final VoidCallback onBack;

  const NameScreen({
    super.key,
    required this.data,
    required this.onNext,
    required this.onBack,
  });

  @override
  State<NameScreen> createState() => _NameScreenState();
}

class _NameScreenState extends State<NameScreen> {
  late TextEditingController _nameController;
  bool _showError = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.data.name);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _handleNext() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() {
        _showError = true;
      });
      return;
    }

    // Update the data with the name
    final updatedData = widget.data.copyWith(name: name);
    widget.onNext(updatedData);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingPageTemplate(
      title: 'What Should We Call You?',
      currentStep: 2,
      totalSteps: 6,
      onBack: widget.onBack,
      onNext: _handleNext,
      nextButtonText: 'Continue',
      isNextEnabled: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Please enter your name so we can personalize your experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppTheme.mediumGray,
              height: 1.5,
            ),
          ),
          const SizedBox(height: AppTheme.spacingXXL),
          InputField(
            controller: _nameController,
            labelText: 'Your Name',
            hintText: 'Enter your name',
            errorText: _showError ? 'Please enter your name' : null,
            showError: _showError,
            onChanged: (value) {
              if (_showError && value.trim().isNotEmpty) {
                setState(() {
                  _showError = false;
                });
              }
            },
          ),
        ],
      ),
    );
  }
}
