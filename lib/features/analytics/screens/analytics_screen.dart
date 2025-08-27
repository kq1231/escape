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
        // Streak Analytics - Load first (most important)
        const SizedBox(height: AppTheme.spacingM),
        _buildLazySection(
          () => StreakActivityGrid(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // Streak Success Rate Card
        _buildLazySection(
          () => StreakSuccessRateCard(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // Prayer Analytics - Load second
        const SizedBox(height: AppTheme.spacingM),
        _buildLazySection(
          () => PrayerActivityGrid(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // Prayer Success Rate Card
        _buildLazySection(
          () => PrayerSuccessRateCard(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // Temptation Analytics - Load third
        Text(
          'Temptation Success Rate',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppTheme.darkGreen,
          ),
        ),
        const SizedBox(height: AppTheme.spacingM),
        _buildLazySection(
          () => TemptationStackedBarChart(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // Temptation Success Rate Card
        _buildLazySection(
          () => TemptationSuccessRateCard(timeRange: _selectedTimeRange),
        ),
        const SizedBox(height: AppTheme.spacingXL),

        // XP Analytics - Load last (least critical for immediate viewing)
        const SizedBox(height: AppTheme.spacingM),
        _buildLazySection(() => XPGrowthChart(timeRange: _selectedTimeRange)),
        const SizedBox(height: AppTheme.spacingXL),
      ],
    );
  }

  /// Builds a section that only loads when it becomes visible
  Widget _buildLazySection(Widget Function() builder) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Use a simple container with minimum height to reserve space
        // The actual widget will be built when it's about to be visible
        return Container(
          constraints: const BoxConstraints(minHeight: 200),
          child: FutureBuilder<Widget>(
            future: Future.microtask(() => builder()),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return snapshot.data!;
              } else if (snapshot.hasError) {
                return Center(
                  child: Text('Error loading section: ${snapshot.error}'),
                );
              } else {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: CircularProgressIndicator(),
                  ),
                );
              }
            },
          ),
        );
      },
    );
  }
}
