import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/relapse_button.dart';

class RelapseConfirmation extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String cancelText;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final VoidCallback? onStreakReset;

  const RelapseConfirmation({
    super.key,
    this.title = 'Record Relapse',
    this.message =
        'Are you sure you want to record this relapse? This action cannot be undone.',
    this.confirmText = 'Yes, Record Relapse',
    this.cancelText = 'Cancel',
    this.onConfirm,
    this.onCancel,
    this.onStreakReset,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: OnboardingTheme.headlineSmall),
      content: Text(message, style: OnboardingTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: OnboardingTheme.labelMedium.copyWith(
              color: OnboardingTheme.primaryGreen,
            ),
          ),
        ),
        RelapseButton(
          text: confirmText,
          onPressed: () {
            // Call the original onConfirm callback
            if (onConfirm != null) {
              onConfirm!();
            }

            // Call the streak reset callback
            if (onStreakReset != null) {
              onStreakReset!();
            }

            // Close the dialog
            Navigator.of(context).pop();
          },
          backgroundColor: OnboardingTheme.errorRed,
          foregroundColor: OnboardingTheme.white,
        ),
      ],
    );
  }
}
