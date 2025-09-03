import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class MotivationCard extends StatelessWidget {
  final String title;
  final String content;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? textColor;

  const MotivationCard({
    super.key,
    required this.title,
    required this.content,
    this.icon,
    this.backgroundColor,
    this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Use theme-aware colors for dark mode
    final cardColor =
        backgroundColor ??
        (isDarkMode
            ? AppConstants.primaryGreen.withValues(alpha: 0.2)
            : AppConstants.lightGreen);
    final textColorValue =
        textColor ?? (isDarkMode ? Colors.white70 : AppConstants.white);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppConstants.spacingXL),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDarkMode ? 0.3 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 48, color: textColorValue),
            const SizedBox(height: AppConstants.spacingL),
          ],
          Text(
            title,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: textColorValue,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: textColorValue,
              fontSize: 18,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

// Predefined Islamic motivation cards
class IslamicMotivationCards {
  static final List<Map<String, dynamic>> cards = [
    {
      'title': 'Allah\'s Promise',
      'content':
          'Allah does not burden a soul beyond that it can bear. (Quran 2:286)',
      'icon': Icons.favorite,
      'backgroundColor': AppConstants.lightGreen,
      'textColor': AppConstants.darkGreen,
    },
    {
      'title': 'Div Mercy',
      'content':
          'Allah is Ar-Rahman, The Most Merciful. His mercy encompasses all things.',
      'icon': Icons.all_inclusive,
      'backgroundColor': AppConstants.lightGreen.withValues(alpha: 0.8),
      'textColor': AppConstants.darkGreen,
    },
    {
      'title': 'You Are In Control',
      'content':
          'You are in control of this moment. Allah has given you the strength to overcome.',
      'icon': Icons.psychology,
      'backgroundColor': AppConstants.lightGreen.withValues(alpha: 0.6),
      'textColor': AppConstants.darkGreen,
    },
    {
      'title': 'Temporary Feeling',
      'content': 'This feeling will pass InshaAllah. You are strong',
      'icon': Icons.hourglass_bottom,
      'backgroundColor': AppConstants.lightGreen.withValues(alpha: 0.4),
      'textColor': AppConstants.darkGreen,
    },
    {
      'title': 'Spiritual Rewards',
      'content':
          'Every moment of resistance is worship. Imagine the sakeenah Allah will place in your heart.',
      'icon': Icons.lightbulb,
      'backgroundColor': AppConstants.lightGreen.withValues(alpha: 0.7),
      'textColor': AppConstants.darkGreen,
    },
    {
      'title': 'Immense AJR',
      'content':
          'Think of the immense ajr (reward) for staying away from haram in the hereafter.',
      'icon': Icons.star,
      'backgroundColor': AppConstants.lightGreen.withValues(alpha: 0.5),
      'textColor': AppConstants.darkGreen,
    },
  ];

  static Widget buildCard(BuildContext context, int index) {
    final cardData = cards[index];
    return MotivationCard(
      title: cardData['title'],
      content: cardData['content'],
      icon: cardData['icon'],
      // Don't pass hardcoded colors to allow theme adaptation
      // backgroundColor: cardData['backgroundColor'],
      // textColor: cardData['textColor'],
    );
  }
}
