import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/models/analytics_models.dart';
import 'package:escape/providers/analytics_providers.dart';
import 'package:intl/intl.dart';

class TemptationActivityGrid extends ConsumerWidget {
  final AnalyticsTimeRange? timeRange;
  const TemptationActivityGrid({super.key, this.timeRange});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final gridDataAsync = ref.watch(
      temptationBarDataProvider(range: timeRange),
    );

    return gridDataAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('Error: $error')),
      data: (gridData) {
        if (gridData.isEmpty) {
          return const Center(child: Text('No temptation data available'));
        }

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Temptation Activity',
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
    List<TemptationBarData> gridData,
  ) {
    // Create efficient lookup map by date
    final dataMap = <String, TemptationBarData>{};
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
      height: 100, // Fixed height for the grid
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

  Widget _buildDayCell(TemptationBarData? data, DateTime date) {
    if (data == null) {
      // No data for this day
      return Tooltip(
        message: "${DateFormat('EEE, MMM d, yyyy').format(date)}\nNo data",
        child: Container(
          decoration: BoxDecoration(
            color: AppConstants.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    final total = data.successfulCount + data.relapseCount;
    if (total == 0) {
      // No temptations recorded
      return Tooltip(
        message:
            "${DateFormat('EEE, MMM d, yyyy').format(date)}\nNo temptations",
        child: Container(
          decoration: BoxDecoration(
            color: AppConstants.lightGray,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    // Calculate percentages
    final successPercentage = data.successfulCount / total;
    final relapsePercentage = data.relapseCount / total;

    // Create tooltip text
    final tooltipText =
        "${DateFormat('EEE, MMM d, yyyy').format(date)}\n"
        "Successful: ${data.successfulCount}\n"
        "Relapsed: ${data.relapseCount}";

    // Case 1: Only successes
    if (data.relapseCount == 0) {
      // Calculate green intensity - more successes = lighter green
      final intensity = (data.successfulCount / 10).clamp(0.0, 1.0);
      final greenColor = _getGreenIntensity(intensity);

      return Tooltip(
        message: tooltipText,
        child: Container(
          decoration: BoxDecoration(
            color: greenColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    // Case 2: Only relapses
    if (data.successfulCount == 0) {
      // Calculate red intensity - more relapses = darker red
      final intensity = (data.relapseCount / 10).clamp(0.0, 1.0);
      final redColor = _getRedIntensity(intensity);

      return Tooltip(
        message: tooltipText,
        child: Container(
          decoration: BoxDecoration(
            color: redColor,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      );
    }

    // Case 3: Both successes and relapses (mixed)
    return Tooltip(
      message: tooltipText,
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
        child: Row(
          children: [
            // Success portion (green)
            Expanded(
              flex: (successPercentage * 100).round(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.successGreen,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(4),
                    bottomLeft: Radius.circular(4),
                  ),
                ),
              ),
            ),
            // Relapse portion (red)
            Expanded(
              flex: (relapsePercentage * 100).round(),
              child: Container(
                decoration: BoxDecoration(
                  color: AppConstants.errorRed,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(4),
                    bottomRight: Radius.circular(4),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Calculate green color based on intensity (more successes = lighter green)
  Color _getGreenIntensity(double intensity) {
    // Start with a base green and make it lighter as intensity increases
    final baseGreen = AppConstants.successGreen;
    final lightGreen = Color.lerp(baseGreen, Colors.white, 0.7)!;
    return Color.lerp(baseGreen, lightGreen, intensity)!;
  }

  // Calculate red color based on intensity (more relapses = darker red)
  Color _getRedIntensity(double intensity) {
    // Start with a base red and make it darker as intensity increases
    final baseRed = AppConstants.errorRed;
    final darkRed = Color.lerp(baseRed, Colors.black, 0.3)!;
    return Color.lerp(baseRed, darkRed, intensity)!;
  }

  Widget _buildLegend(BuildContext context) {
    return Wrap(
      children: [
        _buildLegendItem(context, 'No data', AppConstants.lightGray),
        const SizedBox(width: 16),
        _buildLegendItem(context, 'All successful', AppConstants.successGreen),
        const SizedBox(width: 16),
        _buildLegendItem(context, 'All relapsed', AppConstants.errorRed),
        const SizedBox(width: 16),
        _buildMixedLegendItem(context),
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

  Widget _buildMixedLegendItem(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Container(
              width: 6,
              height: 12,
              decoration: BoxDecoration(
                color: AppConstants.successGreen,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(2),
                  bottomLeft: Radius.circular(2),
                ),
              ),
            ),
            Container(
              width: 6,
              height: 12,
              decoration: BoxDecoration(
                color: AppConstants.errorRed,
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(2),
                  bottomRight: Radius.circular(2),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Text(
          'Mixed',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppConstants.mediumGray),
        ),
      ],
    );
  }
}
