import 'package:flutter/material.dart';
import '../atoms/streak_number.dart';
import '../atoms/streak_label.dart';
import '../atoms/streak_icon.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class StreakDetailScreen extends StatelessWidget {
  final int streakCount;
  final DateTime? startDate;
  final List<DateTime> streakHistory;

  const StreakDetailScreen({
    super.key,
    required this.streakCount,
    this.startDate,
    this.streakHistory = const [],
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Streak'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(OnboardingTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main streak display
            Container(
              padding: const EdgeInsets.all(OnboardingTheme.spacingXXL),
              decoration: BoxDecoration(
                gradient: OnboardingTheme.primaryGradient,
                borderRadius: BorderRadius.circular(OnboardingTheme.radiusXXL),
                boxShadow: OnboardingTheme.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StreakIcon(size: 48, color: OnboardingTheme.white),
                  const SizedBox(height: OnboardingTheme.spacingM),
                  StreakNumber(
                    streakCount: streakCount,
                    color: OnboardingTheme.white,
                    fontSize: 64,
                  ),
                  const SizedBox(height: OnboardingTheme.spacingS),
                  const StreakLabel(
                    text: 'Days Clean',
                    color: OnboardingTheme.white,
                    fontSize: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: OnboardingTheme.spacingXL),

            // Streak information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(OnboardingTheme.spacingL),
              decoration: BoxDecoration(
                color: OnboardingTheme.white,
                borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
                border: Border.all(color: OnboardingTheme.lightGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak Information',
                    style: OnboardingTheme.headlineSmall,
                  ),
                  const SizedBox(height: OnboardingTheme.spacingM),
                  _buildInfoRow('Current Streak', '$streakCount days'),
                  const SizedBox(height: OnboardingTheme.spacingS),
                  _buildInfoRow(
                    'Start Date',
                    startDate != null
                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                        : 'Not recorded',
                  ),
                  const SizedBox(height: OnboardingTheme.spacingS),
                  _buildInfoRow('Longest Streak', '${streakCount + 5} days'),
                ],
              ),
            ),

            const SizedBox(height: OnboardingTheme.spacingL),

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(OnboardingTheme.spacingL),
              decoration: BoxDecoration(
                color: OnboardingTheme.lightGray,
                borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
              ),
              child: Text(
                _getMotivationalMessage(streakCount),
                style: OnboardingTheme.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: OnboardingTheme.bodyMedium.copyWith(
            color: OnboardingTheme.darkGray,
          ),
        ),
        Text(
          value,
          style: OnboardingTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  String _getMotivationalMessage(int streakCount) {
    if (streakCount < 7) {
      return 'Every day clean is a victory. Keep going, you\'re doing great!';
    } else if (streakCount < 30) {
      return 'A week clean is amazing! You\'re building real strength and discipline.';
    } else if (streakCount < 100) {
      return 'A month clean is incredible! Your dedication is truly inspiring.';
    } else {
      return 'Over 100 days clean is extraordinary! You\'ve shown incredible commitment to your journey.';
    }
  }
}
