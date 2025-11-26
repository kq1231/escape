import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../atoms/primary_button.dart';
import 'package:escape/theme/app_constants.dart';

class OnboardingPageTemplate extends StatefulWidget {
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
  State<OnboardingPageTemplate> createState() =>
      _OnboardingPageTemplateState();
}

class _OnboardingPageTemplateState extends State<OnboardingPageTemplate> {
  double _previousProgress = 0.0;
  double _currentProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _currentProgress = widget.totalSteps > 0
        ? widget.currentStep / widget.totalSteps
        : 0.0;
    _previousProgress = _currentProgress;
  }

  @override
  void didUpdateWidget(covariant OnboardingPageTemplate oldWidget) {
    super.didUpdateWidget(oldWidget);

    // ✅ store old progress before updating to the new one
    _previousProgress = oldWidget.totalSteps > 0
        ? oldWidget.currentStep / oldWidget.totalSteps
        : 0.0;

    _currentProgress = widget.totalSteps > 0
        ? widget.currentStep / widget.totalSteps
        : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final double progressBarWidth = MediaQuery.of(context).size.width / 3;

    return Scaffold(
      body: Stack(
        children: [
          // 🌄 Background
          Positioned.fill(
            child: Image.asset(
              'assets/bg.png',
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(color: Colors.white.withOpacity(0.8)),
          ),

          SafeArea(
            child: Column(
              children: [
                // 🧭 Smooth Progress Bar
                if (widget.totalSteps > 1)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 20,
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        if (widget.showBackButton && widget.onBack != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: CupertinoButton(
                              padding: EdgeInsets.zero,
                              onPressed: widget.onBack,
                              child: const Icon(
                                CupertinoIcons.chevron_left,
                                color: Colors.black87,
                                size: 28,
                              ),
                            ),
                          ),
                        SizedBox(
                          width: progressBarWidth,
                          height: 8,
                          child: Stack(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color: AppConstants.mediumGray.withOpacity(0.3),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              TweenAnimationBuilder<double>(
                                tween: Tween<double>(
                                  begin: _previousProgress,
                                  end: _currentProgress,
                                ),
                                duration: const Duration(milliseconds: 900),
                                curve: Curves.easeInOutCubic,
                                builder: (context, value, _) {
                                  return FractionallySizedBox(
                                    alignment: Alignment.centerLeft,
                                    widthFactor: value,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            AppConstants.primaryGreen.withOpacity(0.95),
                                            AppConstants.primaryGreen.withOpacity(0.6),
                                          ],
                                          begin: Alignment.centerLeft,
                                          end: Alignment.centerRight,
                                        ),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppConstants.primaryGreen.withOpacity(0.4),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                // 🪄 Page Content with smooth transition
                Expanded(
                  child: Padding(
                    padding: widget.padding ??
                        const EdgeInsets.symmetric(horizontal: 32),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 500),
                      switchInCurve: Curves.easeInOut,
                      switchOutCurve: Curves.easeInOut,
                      transitionBuilder: (Widget child, Animation<double> anim) {
                        return SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0.2, 0),
                            end: Offset.zero,
                          ).animate(anim),
                          child: FadeTransition(
                            opacity: anim,
                            child: child,
                          ),
                        );
                      },
                      child: Column(
                        key: ValueKey('${widget.title}_${widget.currentStep}'),
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.title.isNotEmpty) ...[
                            Text(
                              widget.title,
                              style: Theme.of(context)
                                  .textTheme
                                  .headlineMedium
                                  ?.copyWith(
                                    color: AppConstants.darkGreen,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                    fontFamily: "Exo",
                                  ),
                            ),
                            if (widget.subtitle != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                widget.subtitle!,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyLarge
                                    ?.copyWith(
                                      color: AppConstants.darkGray
                                          .withValues(alpha: 0.8),
                                      fontWeight: FontWeight.w500,
                                      fontSize: 20,
                                      fontFamily: "Exo",
                                    ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                            const SizedBox(height: 24),
                          ],
                          Expanded(child: widget.child),
                        ],
                      ),
                    ),
                  ),
                ),

                // 📍 Bottom Buttons
                if (widget.showNextButton && widget.onNext != null)
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 24, horizontal: 80),
                    child: Column(
                      children: [
                        PrimaryButton(
                          text: widget.nextButtonText,
                          onPressed: widget.isNextEnabled ? widget.onNext : null,
                          isLoading: widget.isLoading,
                          width: double.infinity,
                        ),
                        if (widget.currentStep == widget.totalSteps)
                          Padding(
                            padding: const EdgeInsets.only(top: 16),
                            child: Text(
                              'Your data is encrypted and never shared',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppConstants.darkGray
                                        .withValues(alpha: 0.6),
                                    fontWeight: FontWeight.w500,
                                    fontFamily: "Exo",
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
        ],
      ),
    );
  }
}
