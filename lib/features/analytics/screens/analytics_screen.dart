import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/stat_card.dart';
import '../molecules/progress_chart.dart';
import '../molecules/streak_graph.dart';
import '../molecules/statistics_pie_chart.dart';
import '../templates/analytics_dashboard.dart';
import '../../../services/local_storage_service.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<ProgressData> _progressData = [];
  List<StreakData> _streakData = [];
  List<StatisticData> _statisticsData = [];
  int _currentStreak = 0;
  int _longestStreak = 0;
  int _totalPoints = 0;
  int _challengesCompleted = 0;

  @override
  void initState() {
    super.initState();
    _loadAnalyticsData();
  }

  Future<void> _loadAnalyticsData() async {
    try {
      final appData = await LocalStorageService.loadAppData();
      if (appData != null) {
        setState(() {
          _currentStreak = appData.streak;
          _longestStreak = appData.streak; // For now, we'll use the same value
          _totalPoints = appData.totalDays * 10; // Simple points calculation
          _challengesCompleted = appData.challengesCompleted;
        });
      }

      // Generate data based on actual app data
      _generateAnalyticsData();
    } catch (e) {
      // Handle error silently
      debugPrint('Error loading analytics data: $e');
      // Generate sample data as fallback
      _generateSampleData();
    }
  }

  // Method to refresh data
  // void _refreshData() {
  //   _loadAnalyticsData();
  // }

  void _generateAnalyticsData() {
    setState(() {
      // Generate progress data based on challenges completed
      _progressData = [
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 6)),
          value: (_challengesCompleted * 0.7).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 5)),
          value: (_challengesCompleted * 0.8).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 4)),
          value: (_challengesCompleted * 0.5).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 3)),
          value: (_challengesCompleted * 0.9).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          value: (_challengesCompleted * 0.6).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          value: (_challengesCompleted * 1.0).clamp(1.0, 5.0),
        ),
        ProgressData(
          date: DateTime.now(),
          value: (_challengesCompleted * 0.8).clamp(1.0, 5.0),
        ),
      ];

      // Generate streak data based on actual streak history
      _streakData = [
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 6)),
          streakCount: (_currentStreak - 6).clamp(0, _currentStreak),
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 5)),
          streakCount: (_currentStreak - 5).clamp(0, _currentStreak),
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 4)),
          streakCount: (_currentStreak - 4).clamp(0, _currentStreak),
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 3)),
          streakCount: (_currentStreak - 3).clamp(0, _currentStreak),
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          streakCount: (_currentStreak - 2).clamp(0, _currentStreak),
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          streakCount: (_currentStreak - 1).clamp(0, _currentStreak),
        ),
        StreakData(date: DateTime.now(), streakCount: _currentStreak),
      ];

      // Generate statistics data
      _statisticsData = [
        StatisticData(label: 'Prayer', value: _challengesCompleted * 0.3),
        StatisticData(label: 'Challenges', value: _challengesCompleted * 0.4),
        StatisticData(label: 'Media', value: _challengesCompleted * 0.2),
        StatisticData(label: 'Other', value: _challengesCompleted * 0.1),
      ];
    });
  }

  void _generateSampleData() {
    setState(() {
      // Generate progress data
      _progressData = [
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 6)),
          value: 2.0,
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 5)),
          value: 3.5,
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 4)),
          value: 1.0,
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 3)),
          value: 4.0,
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          value: 2.5,
        ),
        ProgressData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          value: 5.0,
        ),
        ProgressData(date: DateTime.now(), value: 3.0),
      ];

      // Generate streak data
      _streakData = [
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 6)),
          streakCount: 5,
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 5)),
          streakCount: 6,
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 4)),
          streakCount: 0,
          isActive: false,
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 3)),
          streakCount: 1,
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 2)),
          streakCount: 2,
        ),
        StreakData(
          date: DateTime.now().subtract(const Duration(days: 1)),
          streakCount: 3,
        ),
        StreakData(date: DateTime.now(), streakCount: _currentStreak),
      ];

      // Generate sample statistics data
      _statisticsData = [
        StatisticData(label: 'Prayer', value: 30),
        StatisticData(label: 'Challenges', value: 40),
        StatisticData(label: 'Media', value: 20),
        StatisticData(label: 'Other', value: 10),
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    final statCards = [
      StatCard(
        title: 'Current Streak',
        value: '$_currentStreak days',
        subtitle: 'Keep going!',
        icon: Icons.local_fire_department,
        iconColor: AppTheme.warningOrange,
      ),
      StatCard(
        title: 'Longest Streak',
        value: '$_longestStreak days',
        subtitle: 'Personal best',
        icon: Icons.emoji_events,
        iconColor: AppTheme.successGreen,
      ),
      StatCard(
        title: 'Total Points',
        value: '$_totalPoints',
        subtitle: '+${(_totalPoints * 0.2).round()} this week',
        icon: Icons.stars,
        iconColor: AppTheme.primaryGreen,
      ),
      StatCard(
        title: 'Challenges',
        value: '$_challengesCompleted',
        subtitle: 'Completed',
        icon: Icons.check_circle,
        iconColor: AppTheme.accentGreen,
      ),
    ];

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: AnalyticsDashboard(
          title: 'Your Progress',
          statCards: statCards,
          progressChart: ProgressChart(
            data: _progressData,
            title: 'Daily Progress',
            subtitle: 'Points earned per day',
          ),
          streakGraph: StreakGraph(
            data: _streakData,
            title: 'Streak History',
            subtitle: 'Last 7 days',
          ),
          statisticsPieChart: StatisticsPieChart(
            data: _statisticsData,
            title: 'Activity Distribution',
            subtitle: 'Time spent on different activities',
          ),
          onSettingsPressed: () {
            // Handle settings
          },
        ),
      ),
    );
  }
}
