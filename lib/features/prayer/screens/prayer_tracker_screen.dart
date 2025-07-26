import 'package:flutter/material.dart';
import '../molecules/daily_prayer_grid.dart';
import 'package:escape/theme/app_theme.dart';
import '../../../services/local_storage_service.dart';
import '../../../models/app_data.dart';

class PrayerTrackerScreen extends StatefulWidget {
  const PrayerTrackerScreen({super.key});

  @override
  State<PrayerTrackerScreen> createState() => _PrayerTrackerScreenState();
}

class _PrayerTrackerScreenState extends State<PrayerTrackerScreen> {
  Map<String, bool> _prayerStatus = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
  };

  @override
  void initState() {
    super.initState();
    _loadPrayerData();
  }

  Future<void> _loadPrayerData() async {
    try {
      final appData = await LocalStorageService.loadAppData();
      if (appData != null) {
        // For now, we'll use a simple approach to track prayer status
        // In a real app, you might want to store this in a more structured way
        final today = DateTime.now();
        final dateString = '${today.year}-${today.month}-${today.day}';

        // Load prayer status from preferences
        final prayerPrefs =
            appData.preferences['prayerStatus'] as Map<String, dynamic>? ?? {};
        final todayPrayerStatus =
            prayerPrefs[dateString] as Map<String, dynamic>? ?? {};

        setState(() {
          _prayerStatus = {
            'Fajr': todayPrayerStatus['Fajr'] as bool? ?? false,
            'Dhuhr': todayPrayerStatus['Dhuhr'] as bool? ?? false,
            'Asr': todayPrayerStatus['Asr'] as bool? ?? false,
            'Maghrib': todayPrayerStatus['Maghrib'] as bool? ?? false,
            'Isha': todayPrayerStatus['Isha'] as bool? ?? false,
          };
        });
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading prayer data: $e');
    }
  }

  Future<void> _savePrayerData() async {
    try {
      final appData = await LocalStorageService.loadAppData() ?? AppData();
      final today = DateTime.now();
      final dateString = '${today.year}-${today.month}-${today.day}';

      // Update prayer status in preferences
      final prayerPrefs =
          appData.preferences['prayerStatus'] as Map<String, dynamic>? ?? {};
      prayerPrefs[dateString] = _prayerStatus;
      appData.preferences['prayerStatus'] = prayerPrefs;

      await LocalStorageService.saveAppData(appData);
    } catch (e) {
      // Handle error silently
      debugPrint('Error saving prayer data: $e');
    }
  }

  void _onPrayerStatusChanged(String prayerName, bool isChecked) {
    setState(() {
      _prayerStatus[prayerName] = isChecked;
    });
    _savePrayerData();
    _updatePrayerChallengeProgress();
  }

  Future<void> _updatePrayerChallengeProgress() async {
    try {
      // Load current app data
      final appData = await LocalStorageService.loadAppData() ?? AppData();

      // Check if all prayers are completed for today
      final allPrayersCompleted = _prayerStatus.values.every(
        (status) => status,
      );

      // Update prayer completion status and total days in app data
      final updatedAppData = appData.copyWith(
        isPrayerCompleted: allPrayersCompleted,
        totalDays: allPrayersCompleted && !appData.isPrayerCompleted
            ? appData.totalDays + 1
            : appData.totalDays,
      );

      // Save updated app data
      await LocalStorageService.saveAppData(updatedAppData);
    } catch (e) {
      // Handle error silently
      debugPrint('Error updating prayer challenge progress: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Prayer Tracker',
          style: AppTheme.headlineMedium.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and subtitle
            Text(
              'Daily Prayers',
              style: AppTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 32, // Increased from default headlineMedium size
              ),
            ),
            const SizedBox(height: AppTheme.spacingS),
            Text(
              'Track your salah completion throughout the day',
              style: AppTheme.bodyMedium.copyWith(
                color: AppTheme.mediumGray,
                fontWeight: FontWeight.w500,
                fontSize: 18, // Increased from default bodyMedium size
              ),
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Prayer grid
            DailyPrayerGrid(
              prayerStatus: _prayerStatus,
              onPrayerStatusChanged: _onPrayerStatusChanged,
            ),

            const SizedBox(height: AppTheme.spacingXL),

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(AppTheme.spacingL),
              decoration: BoxDecoration(
                color: AppTheme.lightGray,
                borderRadius: BorderRadius.circular(AppTheme.radiusL),
              ),
              child: Text(
                'Establishing regular prayer (salah) strengthens your connection with Allah and provides spiritual protection throughout your day.',
                style: AppTheme.bodyMedium.copyWith(
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w500,
                  fontSize: 18, // Increased from default bodyMedium size
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(
              height: AppTheme.spacingXL,
            ), // Add extra spacing at bottom
          ],
        ),
      ),
    );
  }
}
