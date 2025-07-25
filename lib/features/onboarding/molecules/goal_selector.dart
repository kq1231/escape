import 'package:flutter/material.dart';
import '../atoms/checkbox_tile.dart';
import '../constants/onboarding_constants.dart';
import '../constants/onboarding_theme.dart';

class GoalSelector extends StatefulWidget {
  final List<String> selectedGoals;
  final ValueChanged<List<String>> onGoalsChanged;
  final bool showError;

  const GoalSelector({
    super.key,
    required this.selectedGoals,
    required this.onGoalsChanged,
    this.showError = false,
  });

  @override
  State<GoalSelector> createState() => _GoalSelectorState();
}

class _GoalSelectorState extends State<GoalSelector> {
  late List<String> _selectedGoals;

  @override
  void initState() {
    super.initState();
    _selectedGoals = List.from(widget.selectedGoals);
  }

  void _toggleGoal(String goal) {
    setState(() {
      if (_selectedGoals.contains(goal)) {
        _selectedGoals.remove(goal);
      } else {
        _selectedGoals.add(goal);
      }
      widget.onGoalsChanged(_selectedGoals);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: OnboardingTheme.spacingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingConstants.goalsTitle,
                style: OnboardingTheme.headlineMedium,
              ),
              const SizedBox(height: OnboardingTheme.spacingS),
              Text(
                OnboardingConstants.goalsSubtitle,
                style: OnboardingTheme.bodyLarge,
              ),
            ],
          ),
        ),
        const SizedBox(height: OnboardingTheme.spacingL),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingTheme.spacingXL,
            ),
            itemCount: OnboardingConstants.goals.length,
            itemBuilder: (context, index) {
              final goal = OnboardingConstants.goals[index];
              return CheckboxTile(
                title: goal,
                value: _selectedGoals.contains(goal),
                onChanged: (value) => _toggleGoal(goal),
                showBorder: true,
              );
            },
          ),
        ),
        if (widget.showError && _selectedGoals.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: OnboardingTheme.spacingXL,
            ),
            child: Text(
              OnboardingConstants.selectAtLeastOne,
              style: OnboardingTheme.bodySmall.copyWith(
                color: OnboardingTheme.errorRed,
              ),
            ),
          ),
      ],
    );
  }
}
