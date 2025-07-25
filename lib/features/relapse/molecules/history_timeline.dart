import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
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
        Text(title, style: OnboardingTheme.headlineMedium),
        SizedBox(height: OnboardingTheme.spacingM),
        if (records.isEmpty) ...[
          Center(
            child: Column(
              children: [
                Icon(
                  Icons.history_toggle_off,
                  size: 48,
                  color: OnboardingTheme.mediumGray,
                ),
                SizedBox(height: OnboardingTheme.spacingM),
                Text(
                  'No relapse records yet',
                  style: OnboardingTheme.bodyMedium.copyWith(
                    color: OnboardingTheme.mediumGray,
                  ),
                ),
                SizedBox(height: OnboardingTheme.spacingM),
                Text(
                  'Keep up the great work!',
                  style: OnboardingTheme.bodyLarge.copyWith(
                    fontWeight: FontWeight.w500,
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
                SizedBox(height: OnboardingTheme.spacingM),
            itemBuilder: (context, index) {
              final record = records[index];
              return HistoryItem(
                title: record.title,
                date: record.date,
                description: record.description,
                icon: record.icon ?? Icons.history,
                iconColor: record.iconColor ?? OnboardingTheme.errorRed,
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
