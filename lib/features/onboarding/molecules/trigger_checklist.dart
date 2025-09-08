import 'package:flutter/material.dart';
import '../atoms/checkbox_tile.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_constants.dart';

class TriggerChecklist extends StatefulWidget {
  final List<String> selectedTriggers;
  final ValueChanged<List<String>> onTriggersChanged;
  final bool showError;

  const TriggerChecklist({
    super.key,
    required this.selectedTriggers,
    required this.onTriggersChanged,
    this.showError = false,
  });

  @override
  State<TriggerChecklist> createState() => _TriggerChecklistState();
}

class _TriggerChecklistState extends State<TriggerChecklist> {
  late List<String> _selectedTriggers;

  @override
  void initState() {
    super.initState();
    _selectedTriggers = List.from(widget.selectedTriggers);
  }

  void _toggleTrigger(String trigger) {
    setState(() {
      if (_selectedTriggers.contains(trigger)) {
        _selectedTriggers.remove(trigger);
      } else {
        _selectedTriggers.add(trigger);
      }
      widget.onTriggersChanged(_selectedTriggers);
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
                OnboardingConstants.triggersTitle,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 32, // Increased from default headlineMedium size
                ),
              ),
              const SizedBox(height: AppConstants.spacingS),
              Text(
                OnboardingConstants.triggersSubtitle,
                style: Theme.of(context).textTheme.bodyLarge,
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
            itemCount: OnboardingConstants.triggers.length,
            itemBuilder: (context, index) {
              final trigger = OnboardingConstants.triggers[index];
              return CheckboxTile(
                title: trigger,
                value: _selectedTriggers.contains(trigger),
                onChanged: (value) => _toggleTrigger(trigger),
                showBorder: true,
              );
            },
          ),
        ),
        if (widget.showError && _selectedTriggers.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppConstants.spacingXL,
            ),
            child: Text(
              OnboardingConstants.selectAtLeastOne,
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: AppConstants.errorRed),
            ),
          ),
      ],
    );
  }
}
