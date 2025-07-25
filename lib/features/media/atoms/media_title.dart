import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class MediaTitle extends StatelessWidget {
  final String title;
  final int? maxLines;
  final TextOverflow overflow;
  final TextAlign textAlign;
  final TextStyle? style;
  final VoidCallback? onTap;

  const MediaTitle({
    super.key,
    required this.title,
    this.maxLines,
    this.overflow = TextOverflow.ellipsis,
    this.textAlign = TextAlign.start,
    this.style,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textWidget = Text(
      title,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: textAlign,
      style: style ?? OnboardingTheme.headlineSmall,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: textWidget);
    }

    return textWidget;
  }
}
