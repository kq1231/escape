import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/providers/xp_controller.dart';
import 'package:escape/theme/app_theme.dart';

class XPConfirmationDialog extends ConsumerWidget {
  final String title;
  final String content;
  final int xpAmount;
  final String xpDescription;
  final VoidCallback onConfirm;

  const XPConfirmationDialog({
    super.key,
    required this.title,
    required this.content,
    required this.xpAmount,
    required this.xpDescription,
    required this.onConfirm,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final xpController = ref.watch(xPControllerProvider);

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.star, color: AppConstants.primaryGreen, size: 28),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppConstants.darkGreen,
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              color: AppConstants.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusM),
              border: Border.all(
                color: AppConstants.primaryGreen.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.add_circle,
                  color: AppConstants.primaryGreen,
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  '+$xpAmount XP',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppConstants.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          style: TextButton.styleFrom(foregroundColor: AppConstants.mediumGray),
          child: const Text('Cancel'),
        ),
        Consumer(
          builder: (context, ref, child) {
            return xpController.when(
              loading: () => const SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppConstants.primaryGreen,
                  ),
                ),
              ),
              error: (error, stack) => TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.errorRed,
                ),
                child: const Text('Retry'),
              ),
              data: (data) => TextButton(
                onPressed: () {
                  onConfirm();
                },
                style: TextButton.styleFrom(
                  foregroundColor: AppConstants.primaryGreen,
                  backgroundColor: AppConstants.primaryGreen.withValues(
                    alpha: 0.1,
                  ),
                ),
                child: const Text('Yes'),
              ),
            );
          },
        ),
      ],
    );
  }
}
