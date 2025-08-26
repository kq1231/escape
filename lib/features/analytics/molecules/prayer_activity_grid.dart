import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';

class PrayerActivityGrid extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;

  const PrayerActivityGrid({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridDataAsync = ref.watch(prayerGridDataProvider(range: timeRange));

    return gridDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (gridData) {
        if (gridData.isEmpty) {
          return const Center(child: Text('No prayer data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Prayer Activity',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              timeRange?.label ?? 'Last 30 days',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppTheme.mediumGray),
            ),
            const SizedBox(height: 20),
            _buildActivityGrid(context, gridData),
            const SizedBox(height: 20),
            _buildLegend(context),
          ],
        );
      },
    );
  }

  Widget _buildActivityGrid(
    BuildContext context,
    List<PrayerGridData> gridData,
  ) {
    // Group data by week
    final weeks = <int, List<PrayerGridData>>{};
    for (final data in gridData) {
      final week = data.date.weekday; // 1 = Monday, 7 = Sunday
      weeks.putIfAbsent(week, () => []).add(data);
    }

    // Sort days of week
    final weekDays = [1, 2, 3, 4, 5, 6, 7];
    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: [
        // Day labels
        Row(
          children: [
            const SizedBox(width: 40), // Space for week numbers
            ...weekDays.map(
              (day) => Expanded(
                child: Center(
                  child: Text(
                    dayLabels[day - 1],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppTheme.mediumGray,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        // Week rows
        ..._generateWeekRows(weeks, weekDays, context),
      ],
    );
  }

  List<Widget> _generateWeekRows(
    Map<int, List<PrayerGridData>> weeks,
    List<int> weekDays,
    BuildContext context,
  ) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 29)); // 30 days ago

    List<Widget> rows = [];

    for (int week = 0; week < 5; week++) {
      final weekStart = startDate.add(Duration(days: week * 7));

      rows.add(
        Row(
          children: [
            // Week number
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  'W${5 - week}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppTheme.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Day cells
            ...weekDays.map((day) {
              final date = weekStart.add(Duration(days: day - 1));
              final dayData = weeks[day]?.firstWhere(
                (data) => _isSameDay(data.date, date),
                orElse: () => PrayerGridData(
                  date: date,
                  prayersCompleted: 0,
                  intensity: 0.0,
                ),
              );

              return Expanded(child: _buildDayCell(context, dayData));
            }),
          ],
        ),
      );
      rows.add(const SizedBox(height: 4));
    }

    return rows;
  }

  Widget _buildDayCell(BuildContext context, PrayerGridData? data) {
    if (data == null) {
      return _buildEmptyCell();
    }

    // Calculate color based on prayer completion
    Color cellColor;
    if (data.prayersCompleted == 0) {
      cellColor = AppTheme.mediumGray;
    } else {
      // Green gradient based on completion rate (0-6 prayers)
      cellColor = _getGreenColor(data.intensity);
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: cellColor,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Center(
        child: data.prayersCompleted > 0
            ? Text(
                '${data.prayersCompleted}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: data.prayersCompleted >= 4
                      ? Colors.white
                      : AppTheme.darkGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 10,
                ),
              )
            : null,
      ),
    );
  }

  Widget _buildEmptyCell() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppTheme.mediumGray),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLegendItem(context, 'No prayers', AppTheme.mediumGray),
            const SizedBox(width: 16),
            _buildLegendItem(context, '1-2 prayers', _getGreenColor(0.25)),
            const SizedBox(width: 16),
            _buildLegendItem(context, '3-4 prayers', _getGreenColor(0.5)),
            const SizedBox(width: 16),
            _buildLegendItem(context, '5-6 prayers', _getGreenColor(0.75)),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          'Each cell shows number of prayers completed (out of 6)',
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppTheme.mediumGray,
            fontStyle: FontStyle.italic,
          ),
        ),
      ],
    );
  }

  Widget _buildLegendItem(BuildContext context, String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppTheme.mediumGray),
        ),
      ],
    );
  }

  Color _getGreenColor(double intensity) {
    // Create gradient from light green to dark green based on intensity
    final baseGreen = AppTheme.lightGreen;
    final darkGreen = AppTheme.primaryGreen;

    return Color.lerp(baseGreen, darkGreen, intensity)!;
  }

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }
}
