import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class HistoryItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
  final IconData icon;
  final Color iconColor;
  final Widget? trailing;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final List<Widget>? additionalInfo;
  final bool isSuccess;

  const HistoryItemCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.date,
    required this.icon,
    required this.iconColor,
    this.trailing,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.additionalInfo,
    this.isSuccess = true,
  });

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = today.subtract(const Duration(days: 1));
    final itemDate = DateTime(date.year, date.month, date.day);

    if (itemDate == today) {
      return 'Today, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else if (itemDate == yesterday) {
      return 'Yesterday, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    } else {
      return '${date.day}/${date.month}/${date.year}, ${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        side: BorderSide(
          color: isSuccess
              ? AppConstants.primaryGreen.withValues(alpha: 0.2)
              : AppConstants.errorRed.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingS),
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(AppConstants.radiusS),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: AppConstants.spacingM),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          subtitle,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppConstants.mediumGray,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Trailing widget or actions
                  if (trailing != null)
                    trailing!
                  else
                    PopupMenuButton<String>(
                      onSelected: (value) {
                        switch (value) {
                          case 'edit':
                            onEdit?.call();
                            break;
                          case 'delete':
                            onDelete?.call();
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        if (onEdit != null)
                          const PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                Icon(Icons.edit, size: 18),
                                SizedBox(width: 8),
                                Text('Edit'),
                              ],
                            ),
                          ),
                        if (onDelete != null)
                          const PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                Icon(Icons.delete, size: 18, color: AppConstants.errorRed),
                                SizedBox(width: 8),
                                Text('Delete', style: TextStyle(color: AppConstants.errorRed)),
                              ],
                            ),
                          ),
                      ],
                    ),
                ],
              ),
              const SizedBox(height: AppConstants.spacingS),
              // Date
              Text(
                _formatDate(date),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppConstants.mediumGray,
                  fontStyle: FontStyle.italic,
                ),
              ),
              // Additional info
              if (additionalInfo != null && additionalInfo!.isNotEmpty) ...[
                const SizedBox(height: AppConstants.spacingM),
                ...additionalInfo!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryInfoChip extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final IconData? icon;

  const HistoryInfoChip({
    super.key,
    required this.label,
    required this.value,
    this.color,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingS,
        vertical: AppConstants.spacingXS,
      ),
      decoration: BoxDecoration(
        color: (color ?? AppConstants.primaryGreen).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusS),
        border: Border.all(
          color: (color ?? AppConstants.primaryGreen).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: color ?? AppConstants.primaryGreen,
            ),
            const SizedBox(width: AppConstants.spacingXS),
          ],
          Text(
            '$label: ',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w500,
              color: color ?? AppConstants.primaryGreen,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color ?? AppConstants.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
