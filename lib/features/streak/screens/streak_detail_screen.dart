import 'package:flutter/material.dart';
import '../atoms/streak_number.dart';
import '../atoms/streak_label.dart';
import '../atoms/streak_icon.dart';
import 'package:escape/theme/app_theme.dart';

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
        title: Text(
          'Your Streak',
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Main streak display
            Container(
              padding: const EdgeInsets.all(AppTheme.spacingXXL),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusXXL),
                boxShadow: AppTheme.cardShadow,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const StreakIcon(size: 48, color: AppTheme.white),
                  const SizedBox(height: AppTheme.spacingM),
                  StreakNumber(
                    streakCount: streakCount,
                    color: AppTheme.white,
                    fontSize: 64,
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  const StreakLabel(
                    text: 'Days Clean',
                    color: AppTheme.white,
                    fontSize: 20,
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Streak information
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.white,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
                border: Border.all(color: AppTheme.lightGray),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Streak Information',
                    style: AppTheme.headlineSmall.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 26, // Increased from default headlineSmall size
                    ),
                  ),
                  const SizedBox(height: AppTheme.spacingM),
                  _buildInfoRow('Current Streak', '$streakCount days'),
                  const SizedBox(height: AppTheme.spacingS),
                  _buildInfoRow(
                    'Start Date',
                    startDate != null
                        ? '${startDate!.day}/${startDate!.month}/${startDate!.year}'
                        : 'Not recorded',
                  ),
                  const SizedBox(height: AppTheme.spacingS),
                  _buildInfoRow('Longest Streak', '${streakCount + 5} days'),
                ],
              ),
            ),

            const SizedBox(height: AppTheme.spacingL),

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Text(
                _getMotivationalMessage(streakCount),
                style: AppTheme.bodyLarge.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontSize: 20, // Increased from default bodyLarge size
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
          style: AppTheme.bodyMedium.copyWith(
            color: AppTheme.darkGray,
            fontWeight: FontWeight.w500,
            fontSize: 18, // Increased from default bodyMedium size
          ),
        ),
        Text(
          value,
          style: AppTheme.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 18, // Increased from default bodyMedium size
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
