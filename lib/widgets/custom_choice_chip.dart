import 'package:flutter/material.dart';
import '../theme/app_theme.dart';

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
              color: selected ? AppTheme.white : AppTheme.white,
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
      selected: selected,
      selectedColor: selectedColor ?? AppTheme.primaryGreen,
      backgroundColor: backgroundColor ?? AppTheme.black,
      onSelected: onSelected,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: EdgeInsets.symmetric(horizontal: labelSpacing ?? 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        side: BorderSide(width: 2, color: AppTheme.white),
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
              color: selected ? AppTheme.white : AppTheme.primaryGreen,
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
            ),
      ),
      selected: selected,
      selectedColor: selectedColor ?? AppTheme.primaryGreen,
      backgroundColor: backgroundColor ?? AppTheme.white,
      onSelected: onSelected,
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      labelPadding: EdgeInsets.symmetric(horizontal: labelSpacing ?? 4),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        side: BorderSide(width: 2, color: AppTheme.primaryGreen),
      ),
    );
  }
}
