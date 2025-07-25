import 'package:flutter/material.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/onboarding/services/storage_service.dart';
import 'features/onboarding/constants/onboarding_theme.dart';
import 'screens/main_app_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Escape - Your Journey to Purity',
      theme: OnboardingTheme.themeData,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }

  Future<void> _checkFirstTimeUser() async {
    await Future.delayed(const Duration(seconds: 2));

    final isFirstTime = await StorageService.isFirstTimeUser();

    if (!mounted) return;

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => isFirstTime
            ? OnboardingFlow(onComplete: _handleOnboardingComplete)
            : const MainApp(),
      ),
    );
  }

  Future<void> _handleOnboardingComplete() async {
    await StorageService.setOnboardingComplete();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const MainAppScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: OnboardingTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Escape',
              style: OnboardingTheme.headlineLarge.copyWith(
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Journey to Purity',
              style: OnboardingTheme.bodyLarge.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MainAppScreen();
  }
}
