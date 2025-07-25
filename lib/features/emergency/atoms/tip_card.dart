import 'package:flutter/material.dart';

class TipCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? iconColor;
  final VoidCallback? onTap;

  const TipCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.backgroundColor,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor =
        backgroundColor ?? Colors.blueAccent.withValues(alpha: 0.1);
    final color = iconColor ?? Colors.blueAccent;

    return Card(
      color: cardColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (icon != null) ...[
                Icon(icon, color: color, size: 24),
                const SizedBox(height: 8),
              ],
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(content, style: const TextStyle(fontSize: 14)),
            ],
          ),
        ),
      ),
    );
  }
}
