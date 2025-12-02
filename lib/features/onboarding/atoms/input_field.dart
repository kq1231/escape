import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

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
    final isFocused = focusNode?.hasFocus ?? false;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
        boxShadow: isFocused
            ? [
                // Bottom right shadow (darker)
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  offset: const Offset(3, 3),
                  blurRadius: 6,
                ),
                // Top left highlight (lighter)
                BoxShadow(
                  color: Colors.white.withOpacity(0.7),
                  offset: const Offset(-3, -3),
                  blurRadius: 6,
                ),
              ]
            : [],
      ),
      child: TextFormField(
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
        style: Theme.of(context).textTheme.bodyLarge,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          errorText: showError ? errorText : null,
          errorMaxLines: 5,
          filled: true,
          fillColor: fillColor ?? AppConstants.lightGray,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
            borderSide: BorderSide(
              color: borderColor ?? Colors.transparent,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            borderSide: BorderSide(
              color: borderColor ?? Colors.grey,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            borderSide: const BorderSide(
              color: AppConstants.primaryGreen,
              width: 3,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            borderSide:
                const BorderSide(color: AppConstants.errorRed, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            borderSide:
                const BorderSide(color: AppConstants.errorRed, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppConstants.spacingM,
            vertical: AppConstants.spacingM,
          ),
          hintStyle: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray),
          labelStyle: Theme.of(context).textTheme.bodyMedium,
          errorStyle: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppConstants.errorRed),
        ),
      ),
    );
  }
}
