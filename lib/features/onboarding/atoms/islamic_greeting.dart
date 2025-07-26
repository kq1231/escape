import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';
import '../constants/onboarding_constants.dart';

class IslamicGreeting extends StatelessWidget {
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const IslamicGreeting({super.key, this.style, this.textAlign, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.only(bottom: AppTheme.spacingL),
      child: Text(
        OnboardingConstants.islamicGreeting,
        style: style ?? AppTheme.islamicText,
        textAlign: textAlign ?? TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
