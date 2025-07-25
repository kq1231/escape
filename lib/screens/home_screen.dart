import 'package:flutter/material.dart';
import '../features/streak/molecules/streak_card.dart';
import '../features/emergency/atoms/emergency_button.dart';
import '../features/emergency/screens/emergency_screen.dart';
import '../features/prayer/molecules/prayer_row.dart';
import '../features/analytics/atoms/stat_card.dart';
import '../features/onboarding/constants/onboarding_theme.dart';
import '../services/local_storage_service.dart';
import '../models/app_data.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // State variables for the home screen
  int _streakCount = 0;
  bool _isEmergencyButtonEnabled = true;

  // Prayer tracking state
  Map<String, bool> _prayerStatus = {
    'Fajr': false,
    'Dhuhr': false,
    'Asr': false,
    'Maghrib': false,
    'Isha': false,
  };

  // Analytics data
  int _totalSessions = 0;
  int _longestStreak = 0;
  int _currentMood = 7; // Scale of 1-10

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final appData = await LocalStorageService.loadAppData();
      if (appData != null) {
        setState(() {
          _streakCount = appData.streak;
          _totalSessions = appData.totalDays;
          _longestStreak = appData.streak; // For now, we'll use the same value
        });
      }

      // Load prayer data
      await _loadPrayerData();
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading home screen data: $e');
    }
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

        // Check if all prayers are completed and update streak if needed
        await _checkAndUpdateStreak(appData, todayPrayerStatus);
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading prayer data: $e');
    }
  }

  Future<void> _checkAndUpdateStreak(
    AppData appData,
    Map<String, dynamic> todayPrayerStatus,
  ) async {
    try {
      // Check if all prayers are completed for today
      final allPrayersCompleted = [
        'Fajr',
        'Dhuhr',
        'Asr',
        'Maghrib',
        'Isha',
      ].every((prayer) => todayPrayerStatus[prayer] as bool? ?? false);

      // Check if it's a new day since last prayer
      final now = DateTime.now();
      final lastPrayerDate = appData.lastPrayerTime != null
          ? DateTime(
              appData.lastPrayerTime!.year,
              appData.lastPrayerTime!.month,
              appData.lastPrayerTime!.day,
            )
          : null;
      final today = DateTime(now.year, now.month, now.day);

      // If all prayers are completed and it's a new day, increment streak
      if (allPrayersCompleted &&
          (lastPrayerDate == null || lastPrayerDate.isBefore(today))) {
        final updatedAppData = appData.copyWith(
          streak: appData.streak + 1,
          lastPrayerTime: now,
        );

        await LocalStorageService.saveAppData(updatedAppData);

        // Update UI
        setState(() {
          _streakCount = updatedAppData.streak;
        });
      }
    } catch (e) {
      // Handle error silently
      debugPrint('Error checking and updating streak: $e');
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

  void _updatePrayerStatus(String prayerName, bool isChecked) {
    setState(() {
      _prayerStatus[prayerName] = isChecked;
    });
    _savePrayerData();
  }

  void _onStreakCardTap() {
    // Navigate to streak details screen
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Navigate to Streak Details')));
  }

  void _onEmergencyButtonPressed() {
    if (_isEmergencyButtonEnabled) {
      // Navigate to emergency screen
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const EmergencyScreen()),
      );
    }
  }

  void _onStatCardTap(String statType) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Navigate to $statType details')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(OnboardingTheme.spacingL),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Streak Counter at the top
            StreakCard(
              streakCount: _streakCount,
              labelText: 'Days Clean',
              onTap: _onStreakCardTap,
              isActive: true,
            ),

            const SizedBox(height: OnboardingTheme.spacingXL),

            // Quick Prayer Status Summary
            Text(
              'Today\'s Prayers',
              style: OnboardingTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: OnboardingTheme.spacingM),

            // Prayer rows
            ..._prayerStatus.entries
                .map(
                  (entry) => Padding(
                    padding: const EdgeInsets.only(
                      bottom: OnboardingTheme.spacingS,
                    ),
                    child: PrayerRow(
                      prayerName: entry.key,
                      isChecked: entry.value,
                      onCheckedChanged: (isChecked) =>
                          _updatePrayerStatus(entry.key, isChecked),
                    ),
                  ),
                )
                .toList(),

            const SizedBox(height: OnboardingTheme.spacingXL),

            // Emergency Button
            Center(
              child: EmergencyButton(
                text: 'Emergency Help',
                onPressed: _onEmergencyButtonPressed,
                icon: Icons.emergency,
                width: double.infinity,
                height: 60,
              ),
            ),

            const SizedBox(height: OnboardingTheme.spacingXL),

            // Quick Stats Mini Analytics Preview
            Text(
              'Quick Stats',
              style: OnboardingTheme.headlineMedium.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: OnboardingTheme.spacingM),

            // Stats grid
            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Sessions',
                    value: '$_totalSessions',
                    subtitle: 'This week',
                    icon: Icons.calendar_today,
                    onTap: () => _onStatCardTap('Sessions'),
                  ),
                ),
                const SizedBox(width: OnboardingTheme.spacingM),
                Expanded(
                  child: StatCard(
                    title: 'Best Streak',
                    value: '$_longestStreak',
                    subtitle: 'All time',
                    icon: Icons.local_fire_department,
                    iconColor: OnboardingTheme.primaryGreen,
                    onTap: () => _onStatCardTap('Streak'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: OnboardingTheme.spacingM),

            Row(
              children: [
                Expanded(
                  child: StatCard(
                    title: 'Mood',
                    value: '$_currentMood/10',
                    subtitle: 'Today',
                    icon: Icons.mood,
                    iconColor: Colors.orange,
                    onTap: () => _onStatCardTap('Mood'),
                  ),
                ),
                const SizedBox(width: OnboardingTheme.spacingM),
                Expanded(
                  child: StatCard(
                    title: 'Progress',
                    value:
                        '${(_streakCount > 0 ? (_streakCount / 30 * 100).round() : 0)}%',
                    subtitle: 'To goal',
                    icon: Icons.trending_up,
                    iconColor: Colors.blue,
                    onTap: () => _onStatCardTap('Progress'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
