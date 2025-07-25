import 'package:flutter/material.dart';
import '../atoms/checkbox_tile.dart';
import '../constants/onboarding_constants.dart';
import '../constants/onboarding_theme.dart';

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
            horizontal: OnboardingTheme.spacingXL,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                OnboardingConstants.triggersTitle,
                style: OnboardingTheme.headlineMedium,
              ),
              const SizedBox(height: OnboardingTheme.spacingS),
              Text(
                OnboardingConstants.triggersSubtitle,
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
