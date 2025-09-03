import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
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
      title: Text(title, style: Theme.of(context).textTheme.headlineSmall),
      content: Text(message, style: Theme.of(context).textTheme.bodyMedium),
      actions: [
        TextButton(
          onPressed: onCancel ?? () => Navigator.of(context).pop(),
          child: Text(
            cancelText,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(color: AppConstants.primaryGreen),
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
          backgroundColor: AppConstants.errorRed,
          foregroundColor: AppConstants.white,
        ),
      ],
    );
  }
}
