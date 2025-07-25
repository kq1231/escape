import 'package:flutter/material.dart';
import '../constants/onboarding_theme.dart';
import '../constants/onboarding_constants.dart';

class IslamicGreeting extends StatelessWidget {
  final TextStyle? style;
  final TextAlign? textAlign;
  final EdgeInsetsGeometry? padding;

  const IslamicGreeting({super.key, this.style, this.textAlign, this.padding});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          padding ?? const EdgeInsets.only(bottom: OnboardingTheme.spacingL),
      child: Text(
        OnboardingConstants.islamicGreeting,
        style: style ?? OnboardingTheme.islamicText,
        textAlign: textAlign ?? TextAlign.center,
        textDirection: TextDirection.rtl,
      ),
    );
  }
}
