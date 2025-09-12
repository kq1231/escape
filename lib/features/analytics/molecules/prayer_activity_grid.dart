import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';
import 'package:intl/intl.dart';

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
            const SizedBox(height: 16),
            _buildActivityGrid(context, gridData),
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

  Widget _buildDayCell(PrayerGridData? data, DateTime date) {
    Color cellColor;

    if (data == null) {
      // No data for this day
      cellColor = AppConstants.lightGray;
    } else if (data.prayersCompleted == 0) {
      // No prayers completed
      cellColor = AppConstants.mediumGray;
    } else {
      // Green gradient based on completion rate (0-6 prayers)
      cellColor = _getGreenColor(data.intensity);
    }

    return Tooltip(
      message:
          "${DateFormat('EEE, MMM d, yyyy').format(date)}"
          "\n${data != null ? "Prayers Completed: ${data.prayersCompleted}/6" : "No data"}",
      child: Container(
        decoration: BoxDecoration(
          color: cellColor,
          borderRadius: BorderRadius.circular(4),
        ),
        child: data != null && data.prayersCompleted > 0
            ? Center(
                child: Text(
                  '${data.prayersCompleted}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 10,
                  ),
                ),
              )
            : null,
      ),
    );
  }

  Color _getGreenColor(double intensity) {
    // Create gradient from light green to dark green based on intensity
    final baseGreen = AppConstants.lightGreen;
    final darkGreen = AppConstants.primaryGreen;
    return Color.lerp(baseGreen, darkGreen, intensity)!;
  }
}
