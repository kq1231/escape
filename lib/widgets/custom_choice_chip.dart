import 'package:flutter/material.dart';
import '../theme/app_constants.dart';

class CustomChoiceChip extends StatelessWidget {
  final String label;
  final bool selected;
  final ValueChanged<bool>? onSelected;
  final Color? selectedColor;
  final Color? backgroundColor;
  final TextStyle? labelStyle;
  final EdgeInsets? padding;
  final double? labelSpacing;

  const CustomChoiceChip({
    super.key,
    required this.label,
    required this.selected,
    this.onSelected,
    this.selectedColor,
    this.backgroundColor,
    this.labelStyle,
    this.padding,
    this.labelSpacing,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.dark) {
      return _buildDarkChoiceChip(context);
    } else {
      return _buildLightChoiceChip(context);
    }
  }

  Widget _buildDarkChoiceChip(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style:
            labelStyle ??
            TextStyle(
              color: selected ? AppConstants.white : AppConstants.white,
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
      selected: selected,
      selectedColor: selectedColor ?? AppConstants.primaryGreen,
      backgroundColor: backgroundColor ?? AppConstants.black,
      onSelected: onSelected,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: EdgeInsets.symmetric(horizontal: labelSpacing ?? 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        side: BorderSide(width: 2, color: AppConstants.white),
      ),
    );
  }

  Widget _buildLightChoiceChip(BuildContext context) {
    return ChoiceChip(
      label: Text(
        label,
        style:
            labelStyle ??
            TextStyle(
              color: selected ? AppConstants.white : AppConstants.primaryGreen,
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
      selected: selected,
      selectedColor: selectedColor ?? AppConstants.primaryGreen,
      backgroundColor: backgroundColor ?? AppConstants.white,
      onSelected: onSelected,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: EdgeInsets.symmetric(horizontal: labelSpacing ?? 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        side: BorderSide(width: 2, color: AppConstants.primaryGreen),
      ),
    );
  }
}
