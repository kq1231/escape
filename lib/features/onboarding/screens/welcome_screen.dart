import 'package:flutter/material.dart';
import '../atoms/islamic_greeting.dart';
import '../atoms/primary_button.dart';
import '../atoms/welcome_text.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_theme.dart';

class WelcomeScreen extends StatelessWidget {
  final VoidCallback onNext;

  const WelcomeScreen({super.key, required this.onNext});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(flex: 2),
              const IslamicGreeting(),
              const SizedBox(height: AppTheme.spacingXXL),
              WelcomeText(
                title: OnboardingConstants.welcomeTitle,
                subtitle: OnboardingConstants.welcomeSubtitle,
                description: OnboardingConstants.welcomeDescription,
              ),
              const Spacer(flex: 3),
              PrimaryButton(
                text: OnboardingConstants.letsGoButton,
                onPressed: onNext,
                width: double.infinity,
              ),
              const SizedBox(height: AppTheme.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
