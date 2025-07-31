import 'package:flutter/material.dart';
import 'custom_choice_chip.dart';

class ChoiceChipGroup extends StatelessWidget {
  final List<String> options;
  final String selectedOption;
  final ValueChanged<String> onSelected;
  final Axis direction;
  final WrapAlignment alignment;
  final double spacing;
  final double runSpacing;

  const ChoiceChipGroup({
    super.key,
    required this.options,
    required this.selectedOption,
    required this.onSelected,
    this.direction = Axis.horizontal,
    this.alignment = WrapAlignment.start,
    this.spacing = 8.0,
    this.runSpacing = 4.0,
  });

  @override
  Widget build(BuildContext context) {
    return direction == Axis.horizontal
        ? Wrap(
            spacing: spacing,
            runSpacing: runSpacing,
            alignment: alignment,
            children: options.map((option) {
              return CustomChoiceChip(
                label: option,
                selected: option == selectedOption,
                onSelected: (selected) {
                  if (selected) {
                    onSelected(option);
                  }
                },
              );
            }).toList(),
          )
        : Column(
            mainAxisSize: MainAxisSize.min,
            children: options.map((option) {
              return Padding(
                padding: EdgeInsets.only(bottom: spacing),
                child: CustomChoiceChip(
                  label: option,
                  selected: option == selectedOption,
                  onSelected: (selected) {
                    if (selected) {
                      onSelected(option);
                    }
                  },
                ),
              );
            }).toList(),
          );
  }
}
