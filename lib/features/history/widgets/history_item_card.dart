import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class HistoryItemCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final DateTime date;
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

  IconData _getIconForPrayer(String prayerName) {
    switch (prayerName) {
      case "Fajr":
        return Icons.wb_twighlight;
      case "Dhuhr":
        return Icons.wb_sunny;
      case "Asr":
        return Icons.sunny_snowing;
      case "Maghrib":
        return Icons.sunny_snowing;
      case "Isha":
        return Icons.nightlight;
      case "Tahajjud":
        return Icons.brightness_3;
      default:
        return Icons.access_time;
    }
  }

  Color _getPrayerColor(String name) {
    switch (name) {
      case "Fajr":
        return const Color(0xFF6B5CE5);
      case "Dhuhr":
        return const Color(0xFFFFC107);
      case "Asr":
        return const Color(0xFFFF9800);
      case "Maghrib":
        return const Color(0xFFF44336);
      case "Isha":
        return const Color(0xFF7B1FA2);
      case "Tahajjud":
        return const Color(0xFF4A148C);
      default:
        return AppConstants.primaryGreen;
    }
  }

  @override
  Widget build(BuildContext context) {
    final prayerColor = _getPrayerColor(title);
    
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(
          color: AppConstants.primaryGreen.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      color: Colors.white,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header row
              Row(
                children: [
                  // Prayer icon with different color background for each prayer
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          prayerColor.withOpacity(0.9),
                          prayerColor.withOpacity(0.7),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: prayerColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Center(
                      child: Icon(
                        _getIconForPrayer(title),
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  // Title and subtitle
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                            fontFamily: 'Exo',
                          ),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: isSuccess 
                                ? AppConstants.primaryGreen.withOpacity(0.1)
                                : AppConstants.errorRed.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSuccess 
                                  ? AppConstants.primaryGreen.withOpacity(0.3)
                                  : AppConstants.errorRed.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.asset(
                                isSuccess 
                                    ? 'assets/checked.png'
                                    : 'assets/missed.png',
                                width: 14,
                                height: 14,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                subtitle,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: isSuccess 
                                      ? AppConstants.primaryGreen
                                      : AppConstants.errorRed,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Status badge with completion icon
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isSuccess 
                          ? AppConstants.primaryGreen.withOpacity(0.1)
                          : AppConstants.errorRed.withOpacity(0.1),
                      border: Border.all(
                        color: isSuccess 
                            ? AppConstants.primaryGreen.withOpacity(0.3)
                            : AppConstants.errorRed.withOpacity(0.3),
                      ),
                    ),
                    child: Image.asset(
                      isSuccess 
                          ? 'assets/checked.png'
                          : 'assets/missed.png',
                      width: 16,
                      height: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  // Actions menu
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: AppConstants.primaryGreen,
                    ),
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
                        PopupMenuItem(
                          value: 'edit',
                          child: Row(
                            children: [
                              Icon(Icons.edit, size: 18, color: AppConstants.primaryGreen),
                              const SizedBox(width: 8),
                              const Text('Edit'),
                            ],
                          ),
                        ),
                      if (onDelete != null)
                        PopupMenuItem(
                          value: 'delete',
                          child: Row(
                            children: [
                              Icon(Icons.delete, size: 18, color: AppConstants.errorRed),
                              const SizedBox(width: 8),
                              const Text('Delete', style: TextStyle(color: AppConstants.errorRed)),
                            ],
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // Date and time
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time,
                      size: 14,
                      color: Colors.grey.shade600,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _formatDate(date),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              // Additional info
              if (additionalInfo != null && additionalInfo!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: additionalInfo!,
                ),
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
    final chipColor = color ?? AppConstants.primaryGreen;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: chipColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: chipColor.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: chipColor.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(
              icon,
              size: 14,
              color: chipColor,
            ),
            const SizedBox(width: 6),
          ],
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: chipColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 12,
              color: chipColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}