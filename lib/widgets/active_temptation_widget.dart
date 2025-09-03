import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/temptation/screens/temptation_flow_screen.dart';
import '../providers/current_active_temptation_provider.dart';
import '../theme/app_theme.dart';

class ActiveTemptationWidget extends ConsumerWidget {
  const ActiveTemptationWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Get theme-aware colors
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDarkMode ? Colors.white : AppConstants.darkGray;
    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.3)
        : AppConstants.errorRed.withValues(alpha: 0.3);
    final backgroundColor = isDarkMode
        ? AppConstants.errorRed.withValues(alpha: 0.2)
        : AppConstants.errorRed.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingL,
        vertical: AppConstants.spacingM,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: isDarkMode ? Colors.white70 : AppConstants.errorRed,
                size: 24,
              ),
              const SizedBox(width: AppConstants.spacingS),
              Expanded(
                child: Text(
                  'Active Temptation Session',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : AppConstants.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'You have an active temptation session. '
            'Would you like to continue where you left off?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor),
          ),
          const SizedBox(height: AppConstants.spacingL),
          // Three buttons: Continue Later, Cancel Session, Continue Now
          Column(
            children: [
              // Cancel Session Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () async {
                    // Cancel the temptation session
                    await ref
                        .read(currentActiveTemptationProvider.notifier)
                        .cancelTemptation();

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  icon: const Icon(Icons.cancel, color: AppConstants.errorRed),
                  label: Text(
                    'Cancel Session',
                    style: TextStyle(
                      color: AppConstants.errorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppConstants.errorRed),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingM,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingM),
              // Row with Continue Later and Continue Now
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Continue Later',
                        style: TextStyle(color: textColor),
                      ),
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const TemptationFlowScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstants.errorRed,
                        foregroundColor: AppConstants.white,
                      ),
                      child: const Text('Continue Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
