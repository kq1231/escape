import 'package:flutter/material.dart';
import '../atoms/checkbox_tile.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_constants.dart';

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
            horizontal: AppConstants.spacingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingConstants.goalsTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32, // Increased from default headlineMedium size
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                OnboardingConstants.goalsSubtitle,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  fontSize: 20, // Increased from default bodyLarge size
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppConstants.spacingL),
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXL,
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
              horizontal: AppConstants.spacingXL,
            ),
            child: Text(
              OnboardingConstants.selectAtLeastOne,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppConstants.errorRed,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
      ],
    );
  }
}
