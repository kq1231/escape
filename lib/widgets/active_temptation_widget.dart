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
    final textColor = isDarkMode ? Colors.white : AppTheme.darkGray;
    final borderColor = isDarkMode
        ? Colors.white.withValues(alpha: 0.3)
        : AppTheme.errorRed.withValues(alpha: 0.3);
    final backgroundColor = isDarkMode
        ? AppTheme.errorRed.withValues(alpha: 0.2)
        : AppTheme.errorRed.withValues(alpha: 0.1);

    return Container(
      padding: const EdgeInsets.all(AppTheme.spacingL),
      margin: const EdgeInsets.symmetric(
        horizontal: AppTheme.spacingL,
        vertical: AppTheme.spacingM,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.radiusXL),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.warning_amber,
                color: isDarkMode ? Colors.white70 : AppTheme.errorRed,
                size: 24,
              ),
              const SizedBox(width: AppTheme.spacingS),
              Expanded(
                child: Text(
                  'Active Temptation Session',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: isDarkMode ? Colors.white70 : AppTheme.errorRed,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppTheme.spacingM),
          Text(
            'You have an active temptation session. '
            'Would you like to continue where you left off?',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: textColor),
          ),
          const SizedBox(height: AppTheme.spacingL),
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
                  icon: const Icon(Icons.cancel, color: AppTheme.errorRed),
                  label: Text(
                    'Cancel Session',
                    style: TextStyle(
                      color: AppTheme.errorRed,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: AppTheme.errorRed),
                    padding: const EdgeInsets.symmetric(
                      vertical: AppTheme.spacingM,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: AppTheme.spacingM),
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
                  const SizedBox(width: AppTheme.spacingM),
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
                        backgroundColor: AppTheme.errorRed,
                        foregroundColor: AppTheme.white,
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
