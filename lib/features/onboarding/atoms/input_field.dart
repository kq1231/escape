import 'package:flutter/material.dart';
import '../constants/onboarding_theme.dart';

class InputField extends StatelessWidget {
  final String? hintText;
  final String? labelText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;
  final int? maxLines;
  final int? maxLength;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final bool enabled;
  final FocusNode? focusNode;
  final bool autofocus;
  final Color? fillColor;
  final Color? borderColor;
  final String? errorText;
  final bool showError;

  const InputField({
    super.key,
    this.hintText,
    this.labelText,
    this.controller,
    this.obscureText = false,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.maxLines = 1,
    this.maxLength,
    this.prefixIcon,
    this.suffixIcon,
    this.enabled = true,
    this.focusNode,
    this.autofocus = false,
    this.fillColor,
    this.borderColor,
    this.errorText,
    this.showError = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      onFieldSubmitted: onSubmitted,
      validator: validator,
      maxLines: maxLines,
      maxLength: maxLength,
      enabled: enabled,
      focusNode: focusNode,
      autofocus: autofocus,
      style: OnboardingTheme.bodyLarge,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: showError ? errorText : null,
        filled: true,
        fillColor: fillColor ?? OnboardingTheme.lightGray,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 1,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
          borderSide: BorderSide(
            color: borderColor ?? Colors.transparent,
            width: 1,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
          borderSide: const BorderSide(
            color: OnboardingTheme.primaryGreen,
            width: 2,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
          borderSide: const BorderSide(
            color: OnboardingTheme.errorRed,
            width: 1,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
          borderSide: const BorderSide(
            color: OnboardingTheme.errorRed,
            width: 2,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: OnboardingTheme.spacingM,
          vertical: OnboardingTheme.spacingM,
        ),
        hintStyle: OnboardingTheme.bodyMedium.copyWith(
          color: OnboardingTheme.mediumGray,
        ),
        labelStyle: OnboardingTheme.bodyMedium,
        errorStyle: OnboardingTheme.bodySmall.copyWith(
          color: OnboardingTheme.errorRed,
        ),
      ),
    );
  }
}
