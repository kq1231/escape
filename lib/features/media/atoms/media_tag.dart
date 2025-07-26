import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
    final bg = backgroundColor ?? AppTheme.primaryGreen;
    final text = textColor ?? AppTheme.white;

    final tagChild = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) ...[
          Icon(icon, size: 16, color: text),
          SizedBox(width: AppTheme.spacingXS),
        ],
        Text(label, style: AppTheme.labelMedium.copyWith(color: text)),
      ],
    );

    final tag = Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppTheme.spacingM,
        vertical: AppTheme.spacingS,
      ),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
      ),
      child: tagChild,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: tag);
    }

    return tag;
  }
}
