import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/providers/goal_provider.dart';
import 'package:escape/widgets/custom_button.dart';
import 'package:escape/widgets/choice_chip_group.dart';

class GoalModal extends ConsumerStatefulWidget {
  const GoalModal({super.key});

  @override
  ConsumerState<GoalModal> createState() => _GoalModalState();
}

class _GoalModalState extends ConsumerState<GoalModal> {
  late int _value;
  late String _unit;

  @override
  void initState() {
    super.initState();
    // Get the goal from the goal provider
    final goal = ref.read(goalProvider);

    // Convert goal to appropriate unit
    if (goal % 365 == 0) {
      _value = goal ~/ 365;
      _unit = 'years';
    } else if (goal % 30 == 0) {
      _value = goal ~/ 30;
      _unit = 'months';
    } else if (goal % 7 == 0) {
      _value = goal ~/ 7;
      _unit = 'weeks';
    } else {
      _value = goal;
      _unit = 'days';
    }
  }

  int _calculateGoalInDays() {
    switch (_unit) {
      case 'years':
        return _value * 365;
      case 'months':
        return _value * 30;
      case 'weeks':
        return _value * 7;
      default: // days
        return _value;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppTheme.radiusXXL),
        ),
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Set Your Goal',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Description
            Text(
              'Set your streak goal. This helps you track your progress and stay motivated.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppTheme.spacingL),

            // Goal input
            Text(
              'Streak Goal:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Number input with increment/decrement buttons and unit selector
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () {
                    setState(() {
                      if (_value > 1) _value--;
                    });
                  },
                ),
                const SizedBox(width: AppTheme.spacingM),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppTheme.spacingL,
                    vertical: AppTheme.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen,
                    borderRadius: BorderRadius.circular(AppTheme.radiusL),
                  ),
                  child: Text(
                    '$_value',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: AppTheme.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spacingM),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () {
                    setState(() {
                      _value++;
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Unit selector
            Center(
              child: ChoiceChipGroup(
                options: const ['Days', 'Weeks', 'Months', 'Years'],
                selectedOption:
                    _unit.substring(0, 1).toUpperCase() + _unit.substring(1),
                onSelected: (String selected) {
                  setState(() {
                    _unit = selected.toLowerCase();
                  });
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Save button
            SizedBox(
              width: double.infinity,
              child: CustomButton(
                text: 'Save Goal',
                onPressed: () async {
                  final goalInDays = _calculateGoalInDays();
                  // Update the goal using the goal provider
                  await ref.read(goalProvider.notifier).updateGoal(goalInDays);

                  // Close the modal
                  if (context.mounted) {
                    Navigator.of(context).pop();
                  }

                  // Show a snackbar confirmation
                  if (context.mounted) {
                    String unitLabel = _unit;
                    if (_unit.endsWith('s')) {
                      unitLabel = _unit.substring(0, _unit.length - 1);
                    }
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Goal updated to $_value $unitLabel!',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: AppTheme.white),
                        ),
                        backgroundColor: AppTheme.successGreen,
                      ),
                    );
                  }
                },
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),
          ],
        ),
      ),
    );
  }
}
