import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
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
              ).textTheme.bodyMedium?.copyWith(color: AppConstants.mediumGray),
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
    // Create efficient lookup map by date
    final dataMap = <String, PrayerGridData>{};
    for (final data in gridData) {
      final key = '${data.date.year}-${data.date.month}-${data.date.day}';
      dataMap[key] = data;
    }

    final dayLabels = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      children: [
        // Day labels
        Row(
          children: [
            const SizedBox(width: 40), // Space for week numbers
            ...dayLabels.map(
              (label) => Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppConstants.mediumGray,
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
        ..._generateWeekRows(dataMap, context),
      ],
    );
  }

  List<Widget> _generateWeekRows(
    Map<String, PrayerGridData> dataMap,
    BuildContext context,
  ) {
    final now = DateTime.now();
    final startDate = now.subtract(const Duration(days: 29)); // 30 days ago

    List<Widget> rows = [];

    // Calculate number of weeks needed
    final totalDays = 30;
    final weeksNeeded = (totalDays / 7).ceil();

    for (int week = 0; week < weeksNeeded; week++) {
      final weekStart = startDate.add(Duration(days: week * 7));

      rows.add(
        Row(
          children: [
            // Week number
            SizedBox(
              width: 40,
              child: Center(
                child: Text(
                  'W${weeksNeeded - week}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppConstants.mediumGray,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            // Day cells for this week
            ...List.generate(7, (dayIndex) {
              final date = weekStart.add(Duration(days: dayIndex));

              // Skip if date is in the future
              if (date.isAfter(now)) {
                return const Expanded(child: SizedBox.shrink());
              }

              // Efficient O(1) lookup
              final key = '${date.year}-${date.month}-${date.day}';
              final dayData = dataMap[key];

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
      cellColor = AppConstants.mediumGray;
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
                      : AppConstants.darkGreen,
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
        color: AppConstants.lightGray,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppConstants.mediumGray),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            _buildLegendItem(context, 'No prayers', AppConstants.mediumGray),
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
            color: AppConstants.mediumGray,
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
          ).textTheme.bodySmall?.copyWith(color: AppConstants.mediumGray),
        ),
      ],
    );
  }

  Color _getGreenColor(double intensity) {
    // Create gradient from light green to dark green based on intensity
    final baseGreen = AppConstants.lightGreen;
    final darkGreen = AppConstants.primaryGreen;

    return Color.lerp(baseGreen, darkGreen, intensity)!;
  }
}
