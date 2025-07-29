import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class PrayerTimeLabel extends StatelessWidget {
  final String prayerName;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;

  const PrayerTimeLabel({
    super.key,
    required this.prayerName,
    this.color,
    this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      prayerName,
      textAlign: textAlign,
      style: Theme.of(context).textTheme.displaySmall?.copyWith(
        fontSize: fontSize ?? 20, // Increased from 18 to 20
        color:
            color ??
            (Theme.of(context).brightness == Brightness.dark
                ? Colors.white70
                : AppTheme.darkGray),
        fontWeight: FontWeight.bold, // Changed from w500 to bold
      ),
    );
  }
}
