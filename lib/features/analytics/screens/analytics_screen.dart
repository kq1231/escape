import 'package:escape/models/analytics_models.dart';
import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../organisms/time_range_filter.dart';
import '../organisms/streak_success_rate_card.dart';
import '../organisms/prayer_success_rate_card.dart';
import '../organisms/temptation_success_rate_card.dart';
import '../molecules/streak_activity_grid.dart';
import '../molecules/prayer_activity_grid.dart';
import '../molecules/temptation_stacked_bar_chart.dart';
import '../molecules/xp_growth_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  AnalyticsTimeRange? _selectedTimeRange;

  void _onTimeRangeChanged(AnalyticsTimeRange? range) {
    setState(() {
      _selectedTimeRange = range;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppTheme.spacingM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title
            Text(
              'Analytics Dashboard',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppTheme.darkGreen,
              ),
            ),
            const SizedBox(height: AppTheme.spacingM),

            // Time range filter
            TimeRangeFilter(
              initialRange: _selectedTimeRange,
              onRangeChanged: _onTimeRangeChanged,
            ),
            const SizedBox(height: AppTheme.spacingXL),

            // Analytics sections
            _buildAnalyticsSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildAnalyticsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Streak Analytics
        const SizedBox(height: AppTheme.spacingM),
        StreakActivityGrid(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        // Streak Success Rate Card
        StreakSuccessRateCard(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        const SizedBox(height: AppTheme.spacingM),
        PrayerActivityGrid(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        // Prayer Success Rate Card
        PrayerSuccessRateCard(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        // Temptation Analytics
        Text(
          'Temptation Success Rate',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGreen,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        TemptationStackedBarChart(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        // Temptation Success Rate Card
        TemptationSuccessRateCard(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),

        // XP Analytics
        const SizedBox(height: AppTheme.spacingM),
        XPGrowthChart(timeRange: _selectedTimeRange),
        const SizedBox(height: AppTheme.spacingXL),
      ],
    );
  }
}
