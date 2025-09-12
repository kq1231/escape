import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';
import 'package:intl/intl.dart';

class StreakActivityGrid extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;
  const StreakActivityGrid({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridDataAsync = ref.watch(streakGridDataProvider(range: timeRange));

    return gridDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (gridData) {
        if (gridData.isEmpty) {
          return const Center(child: Text('No streak data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Streak Activity',
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
            const SizedBox(height: 16),
            _buildActivityGrid(context, gridData),
            const SizedBox(height: 16),
            _buildLegend(context),
          ],
        );
      },
    );
  }

  Widget _buildActivityGrid(
    BuildContext context,
    List<StreakGridData> gridData,
  ) {
    // Create efficient lookup map by date
    final dataMap = <String, StreakGridData>{};
    for (final data in gridData) {
      final key = '${data.date.year}-${data.date.month}-${data.date.day}';
      dataMap[key] = data;
    }

    // Determine date range
    final now = DateTime.now();
    final startDate =
        timeRange?.start ?? now.subtract(const Duration(days: 29));
    final endDate = timeRange?.end ?? now;

    // Calculate total days in range
    final totalDays = endDate.difference(startDate).inDays + 1;

    return SizedBox(
      height: 100, // Approximate height based on weeks
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: totalDays <= 7 ? 7 : 10,
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          childAspectRatio: 1.0,
        ),
        itemCount: totalDays,
        itemBuilder: (context, index) {
          final date = startDate.add(Duration(days: index));
          final key = '${date.year}-${date.month}-${date.day}';
          final dayData = dataMap[key];
          return _buildDayCell(dayData, date);
        },
      ),
    );
  }

  Widget _buildDayCell(StreakGridData? data, DateTime date) {
    Color cellColor;

    if (data == null) {
      // No data for this day
      cellColor = AppConstants.lightGray;
    } else if (data.hasRelapse) {
      // Relapse occurred
      cellColor = AppConstants.errorRed;
    } else {
      // Successful day
      cellColor = AppConstants.primaryGreen;
    }

    return Tooltip(
      message:
          "${DateFormat('EEE, MMM d, yyyy').format(date)}"
          "\n${data != null ? (data.hasRelapse ? "Relapse" : "Success") : "No data"}",

      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    );
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      children: [
        _buildLegendItem(context, 'Successful', AppConstants.primaryGreen),
        const SizedBox(width: 16),
        _buildLegendItem(context, 'Relapse', AppConstants.errorRed),
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
}
