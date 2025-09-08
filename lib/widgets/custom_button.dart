import 'package:flutter/material.dart';
import '../theme/app_constants.dart';

class CustomButton extends StatelessWidget {
  final bool isSelected;
  final String text;
  final Color selectedColor;
  final VoidCallback onPressed;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final ButtonVariant variant;

  const CustomButton({
    super.key,
    this.isSelected = false,
    required this.text,
    this.selectedColor = AppConstants.primaryGreen,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.variant = ButtonVariant.filled,
  });

  const CustomButton.success({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.variant = ButtonVariant.filled,
  }) : selectedColor = AppConstants.successGreen;

  const CustomButton.error({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.variant = ButtonVariant.filled,
  }) : selectedColor = AppConstants.errorRed;

  const CustomButton.danger({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.variant = ButtonVariant.filled,
  }) : selectedColor = AppConstants.errorRed;

  const CustomButton.outline({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.selectedColor = AppConstants.primaryGreen,
  }) : variant = ButtonVariant.outline;

  const CustomButton.filled({
    super.key,
    this.isSelected = false,
    required this.text,
    required this.onPressed,
    this.width,
    this.height,
    this.padding,
    this.selectedColor = AppConstants.primaryGreen,
  }) : variant = ButtonVariant.filled;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;

    if (brightness == Brightness.dark) {
      return _buildDarkButton(context);
    } else {
      return _buildLightButton(context);
    }
  }

  Widget _buildDarkButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.outline:
        return _buildOutlineButton(context, isDark: true);
      case ButtonVariant.filled:
        return _buildFilledButton(context, isDark: true);
    }
  }

  Widget _buildLightButton(BuildContext context) {
    switch (variant) {
      case ButtonVariant.outline:
        return _buildOutlineButton(context, isDark: false);
      case ButtonVariant.filled:
        return _buildFilledButton(context, isDark: false);
    }
  }

  Widget _buildFilledButton(BuildContext context, {required bool isDark}) {
    return SizedBox(
      width: width ?? double.infinity, // This will make it expand
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected
              ? selectedColor
              : isDark
              ? AppConstants.black
              : AppConstants.white,
          foregroundColor: isSelected
              ? AppConstants.white
              : isDark
              ? AppConstants.white
              : AppConstants.darkGreen,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            side: BorderSide(
              color: isSelected
                  ? Colors.transparent
                  : isDark
                  ? AppConstants.white
                  : AppConstants.darkGreen,
              width: 2,
            ),
          ),
          elevation: isSelected ? 4 : 2,
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingS),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }

  Widget _buildOutlineButton(BuildContext context, {required bool isDark}) {
    return SizedBox(
      width: width ?? double.infinity, // This will make it expand
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isSelected ? selectedColor : Colors.transparent,
          foregroundColor: isSelected
              ? AppConstants.white
              : isDark
              ? AppConstants.white
              : AppConstants.darkGreen,
          padding:
              padding ??
              const EdgeInsets.symmetric(vertical: AppConstants.spacingM),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
          ),
          side: BorderSide(
            color: isSelected
                ? selectedColor
                : isDark
                ? AppConstants.white
                : AppConstants.darkGreen,
            width: 2,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingS),
          child: Text(text, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}

enum ButtonVariant { filled, outline }
