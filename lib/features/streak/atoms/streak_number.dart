import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StreakNumber extends StatelessWidget {
  final int streakCount;
  final Color? color;
  final double? fontSize;

  const StreakNumber({
    super.key,
    required this.streakCount,
    this.color,
    this.fontSize,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      '$streakCount',
      style: AppTheme.headlineLarge.copyWith(
        fontSize: fontSize ?? 48,
        fontWeight: FontWeight.bold,
        color: color ?? AppTheme.primaryGreen,
      ),
    );
  }
}
