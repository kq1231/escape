import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class CheckboxTile extends StatelessWidget {
  final String title;
  final bool value;
  final ValueChanged<bool?>? onChanged;
  final bool isSelected;
  final Color? selectedColor;
  final Color? unselectedColor;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final double? borderRadius;
  final bool showBorder;

  const CheckboxTile({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.isSelected = false,
    this.selectedColor,
    this.unselectedColor,
    this.titleStyle,
    this.padding,
    this.borderRadius,
    this.showBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = value
        ? (selectedColor ?? AppConstants.primaryGreen.withValues(alpha: 0.1))
        : (unselectedColor ?? AppConstants.white);

    final borderColor = value
        ? (selectedColor ?? AppConstants.primaryGreen)
        : (showBorder ? AppConstants.mediumGray : Colors.transparent);

    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingS),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.radiusM,
        ),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: showBorder ? AppConstants.cardShadow : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          borderRadius ?? AppConstants.radiusM,
        ),
        onTap: () => onChanged?.call(!value),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingM,
                vertical: AppConstants.spacingM,
              ),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: AppConstants.primaryGreen,
                checkColor: AppConstants.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ?? Theme.of(context).textTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
