import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/relapse_button.dart';
import '../molecules/history_timeline.dart';
import '../molecules/relapse_confirmation.dart';
import '../../../services/local_storage_service.dart';
import '../../../models/app_data.dart';

class RelapseHistoryScreen extends StatefulWidget {
  final VoidCallback? onStreakReset;

  const RelapseHistoryScreen({super.key, this.onStreakReset});

  @override
  State<RelapseHistoryScreen> createState() => _RelapseHistoryScreenState();
}

class _RelapseHistoryScreenState extends State<RelapseHistoryScreen> {
  // Sample data for demonstration
  final relapseRecords = [
    RelapseRecord(
      title: 'Social Media',
      date: 'Yesterday, 2:30 PM',
      description: 'Spent 30 minutes scrolling through social media',
      icon: Icons.phone_android,
      iconColor: AppTheme.warningOrange,
    ),
    RelapseRecord(
      title: 'Inappropriate Content',
      date: '3 days ago, 11:15 AM',
      description: 'Watched inappropriate content online',
      icon: Icons.tv,
      iconColor: AppTheme.errorRed,
    ),
    RelapseRecord(
      title: 'Negative Thoughts',
      date: '1 week ago, 8:45 PM',
      description: 'Struggled with negative thoughts',
      icon: Icons.psychology,
      iconColor: AppTheme.mediumGray,
    ),
  ];

  Future<void> _resetStreak() async {
    try {
      // Load current app data
      final appData = await LocalStorageService.loadAppData() ?? AppData();

      // Reset streak to 0 and add relapse entry
      final updatedAppData = appData.copyWith(
        streak: 0,
        // Reset challenges completed for the day
        challengesCompleted: 0,
        // Add a relapse entry
        relapseHistory: [
          ...appData.relapseHistory,
          RelapseEntry(
            date: DateTime.now(),
            reason: 'User recorded relapse',
            notes: 'Streak reset to 0',
          ),
        ],
      );

      // Save updated app data
      await LocalStorageService.saveAppData(updatedAppData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Relapse recorded and streak reset to 0'),
            backgroundColor: Colors.red,
          ),
        );

        // Notify parent that streak was reset
        if (widget.onStreakReset != null) {
          widget.onStreakReset!();
        }
      }
    } catch (e) {
      // Handle error
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Error recording relapse'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Relapse History',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: AppTheme.darkGreen,
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.darkGreen,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Honest tracking of setbacks helps in understanding patterns and building stronger resistance for the future.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 18, // Increased from default bodyMedium size
              ),
            ),
            SizedBox(height: AppTheme.spacingXL),
            HistoryTimeline(
              records: relapseRecords,
              title: 'Your Relapse History',
              onRecordTap: () {
                // Handle record tap
              },
            ),
            SizedBox(height: AppTheme.spacingXL),
            Center(
              child: RelapseButton(
                text: 'Record New Relapse',
                icon: Icons.add,
                onPressed: () {
                  // Show confirmation dialog
                  showDialog(
                    context: context,
                    builder: (context) => RelapseConfirmation(
                      onConfirm: () {
                        // Handle relapse recording
                      },
                      onStreakReset: _resetStreak,
                      onCancel: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
