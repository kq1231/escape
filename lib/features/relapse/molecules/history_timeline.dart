import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../atoms/history_item.dart';

class HistoryTimeline extends StatelessWidget {
  final List<RelapseRecord> records;
  final String title;
  final VoidCallback? onRecordTap;

  const HistoryTimeline({
    super.key,
    required this.records,
    this.title = 'Relapse History',
    this.onRecordTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 28, // Increased from default headlineMedium size
          ),
        ),
        SizedBox(height: AppConstants.spacingM),
        if (records.isEmpty) ...[
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.history_toggle_off,
                  size: 48,
                  color: AppConstants.mediumGray,
                ),
                SizedBox(height: AppConstants.spacingM),
                Text(
                  'No relapse records yet',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppConstants.mediumGray,
                    fontWeight: FontWeight.w500,
                    fontSize: 18, // Increased from default bodyMedium size
                  ),
                ),
                SizedBox(height: AppConstants.spacingM),
                Text(
                  'Keep up the great work!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 20, // Increased from default bodyLarge size
                  ),
                ),
              ],
            ),
          ),
        ] else ...[
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: records.length,
            separatorBuilder: (context, index) =>
                SizedBox(height: AppConstants.spacingM),
            itemBuilder: (context, index) {
              final record = records[index];
              return HistoryItem(
                title: record.title,
                date: record.date,
                description: record.description,
                icon: record.icon ?? Icons.history,
                iconColor: record.iconColor ?? AppConstants.errorRed,
                onTap: () => onRecordTap?.call(),
              );
            },
          ),
        ],
      ],
    );
  }
}

class RelapseRecord {
  final String title;
  final String date;
  final String? description;
  final IconData? icon;
  final Color? iconColor;

  const RelapseRecord({
    required this.title,
    required this.date,
    this.description,
    this.icon,
    this.iconColor,
  });
}
