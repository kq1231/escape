import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.title,
    required this.date,
    this.description,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: EdgeInsets.all(AppTheme.spacingM),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(AppTheme.spacingS),
                  decoration: BoxDecoration(
                    color:
                        iconColor?.withValues(alpha: 0.1) ??
                        AppTheme.errorRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? AppTheme.errorRed,
                    size: 24,
                  ),
                ),
                SizedBox(width: AppTheme.spacingM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    SizedBox(height: AppTheme.spacingXS),
                    Text(
                      date,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppTheme.mediumGray,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: AppTheme.spacingS),
                      Text(
                        description!,
                        style: Theme.of(context).textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
