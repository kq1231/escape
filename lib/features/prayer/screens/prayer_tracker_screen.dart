import 'package:flutter/material.dart';
import '../molecules/daily_prayer_grid.dart';
import '../../onboarding/constants/onboarding_theme.dart';
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
        title: const Text('Prayer Tracker'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(OnboardingTheme.spacingXL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and subtitle
            Text('Daily Prayers', style: OnboardingTheme.headlineMedium),
            const SizedBox(height: OnboardingTheme.spacingS),
            Text(
              'Track your salah completion throughout the day',
              style: OnboardingTheme.bodyMedium.copyWith(
                color: OnboardingTheme.mediumGray,
              ),
            ),
            const SizedBox(height: OnboardingTheme.spacingXL),

            // Prayer grid
            DailyPrayerGrid(
              prayerStatus: _prayerStatus,
              onPrayerStatusChanged: _onPrayerStatusChanged,
            ),

            const SizedBox(height: OnboardingTheme.spacingXL),

            // Motivational message
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(OnboardingTheme.spacingL),
              decoration: BoxDecoration(
                color: OnboardingTheme.lightGray,
                borderRadius: BorderRadius.circular(OnboardingTheme.radiusL),
              ),
              child: Text(
                'Establishing regular prayer (salah) strengthens your connection with Allah and provides spiritual protection throughout your day.',
                style: OnboardingTheme.bodyMedium.copyWith(
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
}
