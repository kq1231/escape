import 'package:escape/widgets/theme_loader.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/onboarding/services/storage_service.dart';
import 'screens/main_app_screen.dart';
import 'theme/app_theme.dart';
import 'theme/theme_provider.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Escape - Your Journey to Purity',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ref.watch(themeProvider),
      home: const ThemeLoader(child: SplashScreen()),
      debugShowCheckedModeBanner: false,
    );
  }
}

class ThemeLoaderWidget extends ConsumerStatefulWidget {
  const ThemeLoaderWidget({super.key});

  @override
  ConsumerState<ThemeLoaderWidget> createState() => _ThemeLoaderWidgetState();
}

class _ThemeLoaderWidgetState extends ConsumerState<ThemeLoaderWidget> {
  bool _themeLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadSavedTheme();
  }

  Future<void> _loadSavedTheme() async {
    final savedTheme = await ThemeService.loadTheme();
    if (mounted) {
      ref.read(themeProvider.notifier).state = savedTheme;
      setState(() {
        _themeLoaded = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_themeLoaded) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return const SplashScreen();
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
    // Theme is already loaded, check if user is first time
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
      backgroundColor: AppTheme.primaryGreen,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.mosque, size: 80, color: Colors.white),
            const SizedBox(height: 20),
            Text(
              'Escape',
              style: AppTheme.headlineLarge.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Journey to Purity',
              style: AppTheme.bodyLarge.copyWith(
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
