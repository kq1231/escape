import 'package:escape/features/onboarding/atoms/liquid_border_painter.dart';
import 'package:flutter/material.dart';
import '../constants/onboarding_constants.dart';
import 'package:escape/theme/app_constants.dart';

class WelcomeScreen extends StatefulWidget {
  final VoidCallback onNext;

  const WelcomeScreen({super.key, required this.onNext});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with TickerProviderStateMixin {
  late AnimationController _controller;
  late AnimationController _borderController;
  late AnimationController _buttonScaleController;

  late Animation<Offset> _titleSlideAnimation;
  late Animation<Offset> _imageSlideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _buttonScaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _titleSlideAnimation = Tween<Offset>(
      begin: const Offset(2.0, 0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _imageSlideAnimation = Tween<Offset>(
      begin: const Offset(-2.0, 0),
      end: const Offset(-0.2, 0),
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    // Border animation
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    // Button scale animation
    _buttonScaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _buttonScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _buttonScaleController, curve: Curves.easeOutBack),
    );

    // Start animations
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _controller.forward();
      await Future.delayed(const Duration(milliseconds: 300));
      _buttonScaleController.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _borderController.dispose();
    _buttonScaleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 30, 106, 58),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppConstants.spacingXL),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: AppConstants.spacingXXL),

              // 👇 Title slides in from RIGHT
              SlideTransition(
                position: _titleSlideAnimation,
                child: Text(
                  OnboardingConstants.welcomeTitle,
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: AppConstants.spacingXXL),

              // 👇 Image slides from LEFT + fades
              SlideTransition(
                position: _imageSlideAnimation,
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: Image.asset(
                    "assets/muslim.png",
                    height: 400,
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // 👇 Description fades in same time as image
              FadeTransition(
                opacity: _fadeAnimation,
                child: Text(
                  OnboardingConstants.welcomeDescription,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
              ),

              const Spacer(flex: 2),

              // 👇 Button appears after others
              ScaleTransition(
                scale: _buttonScaleAnimation,
                child: LiquidBorderButton(
                  animation: _borderController,
                  onTap: widget.onNext,
                  child: Text(
                    OnboardingConstants.letsGoButton,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ),

              const SizedBox(height: AppConstants.spacingL),
            ],
          ),
        ),
      ),
    );
  }
}
