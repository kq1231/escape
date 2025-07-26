import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class StreakLabel extends StatelessWidget {
  final String text;
  final Color? color;
  final double? fontSize;
  final TextAlign? textAlign;

  const StreakLabel({
    super.key,
    this.text = 'Days Clean',
    this.color,
    this.fontSize,
    this.textAlign,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: textAlign,
      style: AppTheme.headlineSmall.copyWith(
        fontSize: fontSize ?? 20,
        color: color ?? AppTheme.darkGray,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}
