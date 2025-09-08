import 'package:escape/models/challenge_model.dart';
import 'package:escape/models/user_profile_model.dart' as user_profile;
import 'package:escape/providers/user_profile_provider.dart';
import 'package:escape/providers/challenges_watcher_provider.dart';
import 'package:escape/screens/main_app_screen.dart';
import 'package:escape/theme/app_theme.dart';
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

/// Beautiful Achievement Overlay Widget
class AchievementOverlay extends StatefulWidget {
  final List<Challenge> challenges;

  const AchievementOverlay({super.key, required this.challenges});

  @override
  State<AchievementOverlay> createState() => _AchievementOverlayState();
}

class _AchievementOverlayState extends State<AchievementOverlay>
    with TickerProviderStateMixin {
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  int _currentIndex = 0;
  bool _isVisible = true; // Track visibility

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _showNextAchievement();
  }

  void _setupAnimations() {
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0, -1.5), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _slideController,
            curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
          ),
        );

    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeInOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: const Interval(0.0, 0.4, curve: Curves.elasticOut),
      ),
    );

    // Gentle pulse effect
    _pulseController.repeat(reverse: true);
  }

  void _showNextAchievement() async {
    if (_currentIndex < widget.challenges.length) {
      // Show the current achievement
      setState(() {
        _isVisible = true;
      });

      // Slide in
      await _slideController.forward();

      // Show for 5 seconds
      await Future.delayed(const Duration(seconds: 5));

      // Slide out
      await _slideController.reverse();

      if (mounted) {
        setState(() {
          _currentIndex++;
          // Hide if this was the last achievement
          if (_currentIndex >= widget.challenges.length) {
            _isVisible = false;
          }
        });

        // Small delay before showing next achievement
        await Future.delayed(const Duration(milliseconds: 300));
        _showNextAchievement();
      }
    } else {
      // All achievements shown, hide overlay
      setState(() {
        _isVisible = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _currentIndex >= widget.challenges.length) {
      return const SizedBox.shrink();
    }

    final challenge = widget.challenges[_currentIndex];

    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: AnimatedBuilder(
            animation: _pulseController,
            builder: (context, child) {
              return Transform.scale(
                scale: 1.0 + (_pulseController.value * 0.02), // Subtle pulse
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: _getGradientColors(challenge.featureName),
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 3,
                        offset: const Offset(0, 10),
                      ),
                      BoxShadow(
                        color: _getFeatureColor(
                          challenge.featureName,
                        ).withValues(alpha: 0.4),
                        blurRadius: 30,
                        spreadRadius: -5,
                        offset: const Offset(0, 15),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Header with icon and celebration
                      Row(
                        children: [
                          Container(
                            width: 70,
                            height: 70,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.15),
                                  blurRadius: 10,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            child: Icon(
                              _getFeatureIcon(challenge.featureName),
                              color: _getFeatureColor(challenge.featureName),
                              size: 36,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '🎉 Masha\'Allah!',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Challenge Completed',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Challenge details
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              challenge.title,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              challenge.description,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 15,
                                height: 1.3,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Footer with blessing
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Barakallahu feek! 🤲',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${_currentIndex + 1}/${widget.challenges.length}',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  List<Color> _getGradientColors(String feature) {
    return switch (feature) {
      'streak' => [
        Colors.orange.shade600,
        Colors.orange.shade700,
        Colors.red.shade600,
      ],
      'prayer' => [
        Colors.blue.shade600,
        Colors.blue.shade700,
        Colors.indigo.shade600,
      ],
      'temptation' => [
        Colors.purple.shade600,
        Colors.purple.shade700,
        Colors.pink.shade600,
      ],
      _ => [Colors.grey.shade600, Colors.grey.shade700, Colors.grey.shade800],
    };
  }

  IconData _getFeatureIcon(String feature) {
    return switch (feature) {
      'streak' => Icons.local_fire_department,
      'prayer' => Icons.mosque,
      'temptation' => Icons.shield,
      _ => Icons.emoji_events,
    };
  }

  Color _getFeatureColor(String feature) {
    return switch (feature) {
      'streak' => Colors.orange.shade700,
      'prayer' => Colors.blue.shade700,
      'temptation' => Colors.purple.shade700,
      _ => Colors.grey.shade700,
    };
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
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
