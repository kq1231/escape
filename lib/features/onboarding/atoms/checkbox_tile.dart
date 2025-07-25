import 'package:flutter/material.dart';
import '../constants/onboarding_theme.dart';

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
        ? (selectedColor ?? OnboardingTheme.primaryGreen.withValues(alpha: 0.1))
        : (unselectedColor ?? OnboardingTheme.white);

    final borderColor = value
        ? (selectedColor ?? OnboardingTheme.primaryGreen)
        : (showBorder ? OnboardingTheme.mediumGray : Colors.transparent);

    return Container(
      margin: const EdgeInsets.only(bottom: OnboardingTheme.spacingS),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? OnboardingTheme.radiusM,
        ),
        border: Border.all(color: borderColor, width: 1),
        boxShadow: showBorder ? OnboardingTheme.cardShadow : null,
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(
          borderRadius ?? OnboardingTheme.radiusM,
        ),
        onTap: () => onChanged?.call(!value),
        child: Padding(
          padding:
              padding ??
              const EdgeInsets.symmetric(
                horizontal: OnboardingTheme.spacingM,
                vertical: OnboardingTheme.spacingM,
              ),
          child: Row(
            children: [
              Checkbox(
                value: value,
                onChanged: onChanged,
                activeColor: OnboardingTheme.primaryGreen,
                checkColor: OnboardingTheme.white,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              const SizedBox(width: OnboardingTheme.spacingS),
              Expanded(
                child: Text(
                  title,
                  style: titleStyle ?? OnboardingTheme.bodyLarge,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
