import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/streak/organisms/streak_organism.dart';
import '../features/emergency/atoms/emergency_button.dart';
import '../features/temptation/screens/temptation_flow_screen.dart';
import '../features/history/screens/temptation_history_screen.dart';
import '../features/prayer/molecules/daily_prayer_grid.dart';
import '../features/analytics/organisms/quick_stats_organism.dart';
import 'package:escape/theme/app_constants.dart';
import '../providers/has_active_temptation_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  // State variables for the home screen
  final bool _isEmergencyButtonEnabled = true;

  void _onEmergencyButtonPressed(BuildContext context) {
    if (_isEmergencyButtonEnabled) {
      // Navigate to emergency screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TemptationFlowScreen()),
      );
    }
  }

  void _onHistoryButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TemptationHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final hasActiveTemptation = ref.watch(hasActiveTemptationProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Show active temptation warning if exists
              if (hasActiveTemptation) ...[
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingL),
                  margin: const EdgeInsets.symmetric(
                    horizontal: 0,
                    vertical: AppConstants.spacingM,
                  ),
                  decoration: BoxDecoration(
                    color: AppConstants.errorRed.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                    border: Border.all(
                      color: AppConstants.errorRed.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.warning_amber,
                            color: AppConstants.errorRed,
                            size: 24,
                          ),
                          const SizedBox(width: AppConstants.spacingS),
                          Text(
                            'Active Temptation Session',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: AppConstants.errorRed,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingM),
                      Text(
                        'You have an ongoing temptation session. '
                        'Tap below to continue your journey.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).brightness == Brightness.light
                              ? AppConstants.darkGray
                              : AppConstants.white,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingL),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const TemptationFlowScreen(),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstants.errorRed,
                            foregroundColor: AppConstants.white,
                          ),
                          child: const Text('Continue Session'),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppConstants.spacingXL),
              ],
              StreakOrganism(labelText: 'Days Clean', isActive: true),

              const SizedBox(height: AppConstants.spacingXL),

              DailyPrayerGrid(),

              const SizedBox(height: AppConstants.spacingXL),

              // Emergency Button and History Button Row
              Row(
                children: [
                  // Emergency Button - takes most of the space
                  Expanded(
                    flex: 3,
                    child: EmergencyButton(
                      text: 'I Need Help',
                      onPressed: () => _onEmergencyButtonPressed(context),
                      icon: Icons.favorite,
                      height: 60,
                    ),
                  ),

                  const SizedBox(width: AppConstants.spacingS),

                  // History Button - smaller, to the right
                  Container(
                    height: 40,
                    width: 30,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppConstants.radiusL),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () => _onHistoryButtonPressed(context),
                        borderRadius: BorderRadius.circular(
                          AppConstants.radiusL,
                        ),
                        child: const Icon(
                          Icons.history,
                          color: Colors.grey,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Quick Stats Mini Analytics Preview
              QuickStatsOrganism(),
            ],
          ),
        ),
      ),
    );
  }
}
