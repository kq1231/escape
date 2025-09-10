import 'package:escape/features/challenges/widgets/achievement_overlay.dart';
import 'package:escape/models/user_profile_model.dart' as user_profile;
import 'package:escape/providers/user_profile_provider.dart';
import 'package:escape/providers/challenges_watcher_provider.dart';
import 'package:escape/screens/main_app_screen.dart';
import 'package:escape/theme/app_constants.dart';
import 'package:escape/theme/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/onboarding/onboarding_flow.dart';

/// A widget that displays a loading state with a MaterialApp
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: AppConstants.lightTheme,
      darkTheme: AppConstants.darkTheme,
      home: SplashScreen(),
    );
  }
}

/// A widget that displays an error state with a MaterialApp
class AppStartupErrorWidget extends ConsumerWidget {
  final String message;
  final VoidCallback onRetry;

  const AppStartupErrorWidget({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      home: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 16),
            Text(
              'Initialization Error',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: 24),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class AppStartupSuccessWidget extends ConsumerWidget {
  const AppStartupSuccessWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    user_profile.UserProfile? userProfile = ref
        .read(userProfileProvider)
        .requireValue;
    final themeModeAsync = ref.watch(themeModeNotifierProvider);

    return userProfile != null
        ? themeModeAsync.when(
            data: (data) {
              return MaterialApp(
                theme: AppConstants.lightTheme,
                darkTheme: AppConstants.darkTheme,
                themeMode: data,
                home: const MainAppScreen(),
                builder: (context, child) {
                  return Stack(
                    children: [
                      child!, // Your main app content
                      // Global Achievement Overlay - positioned on top
                      Consumer(
                        builder: (context, ref, _) {
                          return ref
                              .watch(challengesWatcherProvider)
                              .when(
                                data: (newAchievements) =>
                                    newAchievements.isNotEmpty
                                    ? Positioned(
                                        top:
                                            MediaQuery.of(context).padding.top +
                                            20,
                                        left: 16,
                                        right: 16,
                                        child: Material(
                                          color: Colors.transparent,
                                          child: AchievementOverlay(
                                            challenges: newAchievements,
                                          ),
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                                loading: () => const SizedBox.shrink(),
                                error: (_, _) => const SizedBox.shrink(),
                              );
                        },
                      ),
                    ],
                  );
                },
              );
            },
            loading: () => const MaterialApp(
              home: Scaffold(body: Center(child: CircularProgressIndicator())),
            ),
            error: (error, stack) => MaterialApp(
              home: Scaffold(
                body: Center(child: Text('Error loading theme: $error')),
              ),
            ),
          )
        : MaterialApp(
            theme: AppConstants.lightTheme,
            darkTheme: AppConstants.darkTheme,
            themeMode: ThemeMode.light,
            home: OnboardingFlow(
              onComplete: (ctx) => Navigator.of(ctx).pushReplacement(
                MaterialPageRoute(builder: (context) => MainAppScreen()),
              ),
            ),
          );
  }
}

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.primaryGreen,
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
