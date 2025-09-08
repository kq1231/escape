import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class MediaTag extends StatelessWidget {
  final String label;
  final Color? backgroundColor;
  final Color? textColor;
  final VoidCallback? onTap;
  final IconData? icon;

  const MediaTag({
    super.key,
    required this.label,
    this.backgroundColor,
    this.textColor,
    this.onTap,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final bg = backgroundColor ?? AppConstants.primaryGreen;
    final text = textColor ?? AppConstants.white;

    final tagChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: text),
          SizedBox(width: AppConstants.spacingXS),
        ],
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(color: text),
        ),
      ],
    );

    final tag = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppConstants.spacingM,
        vertical: AppConstants.spacingS,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppConstants.radiusL),
      ),
      child: tagChild,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: tag);
    }

    return tag;
  }
}
