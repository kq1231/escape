import 'package:flutter/material.dart';
import '../atoms/progress_indicator.dart' as custom;
import '../atoms/primary_button.dart';
import 'package:escape/theme/app_theme.dart';

class OnboardingPageTemplate extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget child;
  final VoidCallback? onNext;
  final VoidCallback? onBack;
  final bool showBackButton;
  final bool showNextButton;
  final String nextButtonText;
  final bool isNextEnabled;
  final bool isLoading;
  final int currentStep;
  final int totalSteps;
  final EdgeInsetsGeometry? padding;

  const OnboardingPageTemplate({
    super.key,
    required this.title,
    this.subtitle,
    required this.child,
    this.onNext,
    this.onBack,
    this.showBackButton = true,
    this.showNextButton = true,
    this.nextButtonText = 'Next',
    this.isNextEnabled = true,
    this.isLoading = false,
    required this.currentStep,
    required this.totalSteps,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.white,
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        elevation: 0,
        leading: showBackButton && onBack != null
            ? IconButton(
                icon: const Icon(Icons.arrow_back),
                color: AppTheme.darkGray,
                onPressed: onBack,
              )
            : null,
        actions: const [], // Removed skip button
      ),
      body: SafeArea(
        child: Column(
          children: [
            if (totalSteps > 1)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: custom.ProgressIndicator(
                  currentStep: currentStep,
                  totalSteps: totalSteps,
                  showDots: true,
                  showBar: true,
                ),
              ),
            Expanded(
              child: Padding(
                padding: padding ?? const EdgeInsets.symmetric(horizontal: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title.isNotEmpty) ...[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineMedium
                            ?.copyWith(
                              color: AppTheme.darkGray,
                              fontWeight: FontWeight.bold,
                              fontSize:
                                  32, // Increased from default headlineMedium size
                            ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          subtitle!,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppTheme.darkGray.withValues(alpha: 0.8),
                                fontWeight: FontWeight.w500,
                                fontSize:
                                    20, // Increased from default bodyLarge size
                              ),
                        ),
                      ],
                      const SizedBox(height: 24),
                    ],
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
            if (showNextButton && onNext != null)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    PrimaryButton(
                      text: nextButtonText,
                      onPressed: isNextEnabled ? onNext : null,
                      isLoading: isLoading,
                      width: double.infinity,
                    ),
                    if (currentStep == totalSteps)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Text(
                          'Your data is encrypted and never shared',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppTheme.darkGray.withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
