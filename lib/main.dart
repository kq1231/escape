import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'features/onboarding/onboarding_flow.dart';
import 'features/onboarding/services/storage_service.dart';
import 'screens/main_app_screen.dart';
import 'theme/app_theme.dart';
import 'providers/app_startup_provider.dart';
import 'widgets/app_startup_state_widgets.dart';
import 'theme/theme_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: AppStartupWidget()));
}

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      // Loading state
      loading: () => const AppStartupLoadingWidget(),

      // Error state
      error: (error, stackTrace) => AppStartupErrorWidget(
        message: error.toString(),
        onRetry: () => ref.read(appStartupProvider.notifier).retry(),
      ),

      // Success state
      data: (_) => const AppStartupSuccessWidget(child: MyApp()),
    );
  }
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Watch the theme mode from our new provider
    final themeModeAsync = ref.watch(themeModeNotifierProvider);

    return themeModeAsync.when(
      loading: () => MaterialApp(
        title: 'Escape - Your Journey to Purity',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
        debugShowCheckedModeBanner: false,
      ),
      error: (error, stack) => MaterialApp(
        title: 'Escape - Your Journey to Purity',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        home: Scaffold(
          body: Center(child: Text('Error loading theme: $error')),
        ),
        debugShowCheckedModeBanner: false,
      ),
      data: (themeMode) => MaterialApp(
        title: 'Escape - Your Journey to Purity',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: themeMode,
        home: const ThemeLoader(child: SplashScreen()),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class ThemeLoader extends ConsumerWidget {
  final Widget child;

  const ThemeLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // The theme is now loaded through our provider, so we can just return the child
    return child;
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
              style: Theme.of(
                context,
              ).textTheme.displayLarge?.copyWith(color: Colors.white),
            ),
            const SizedBox(height: 10),
            Text(
              'Your Journey to Purity',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.white.withValues(alpha: 0.8),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MainApp extends ConsumerWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const MainAppScreen();
  }
}
