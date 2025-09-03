import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/providers/xp_controller.dart';
import 'package:escape/theme/app_theme.dart';
import 'package:google_fonts/google_fonts.dart';

class TawbahScreen extends ConsumerStatefulWidget {
  const TawbahScreen({super.key});

  @override
  ConsumerState<TawbahScreen> createState() => _TawbahScreenState();
}

class _TawbahScreenState extends ConsumerState<TawbahScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeInAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _fadeInAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [AppConstants.lightGreen, AppConstants.darkGreen],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Animated title
              FadeTransition(
                opacity: _fadeInAnimation,
                child: Text(
                  'Allah is The Most Merciful',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    fontSize: 28,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: AppConstants.spacingXL),

              // Mercy message
              Expanded(
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Allah's mercy reminder
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingL),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusXL,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Remember Allah\'s Infinite Mercy',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: AppConstants.spacingM),
                              Text(
                                'Allah says in the Quran:',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                      fontStyle: FontStyle.italic,
                                    ),
                              ),
                              const SizedBox(height: AppConstants.spacingS),
                              Container(
                                padding: const EdgeInsets.all(
                                  AppConstants.spacingM,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(
                                    AppConstants.radiusM,
                                  ),
                                ),
                                child: Text(
                                  '"Say: O my servants who have transgressed against themselves [by sinning], do not despair of the mercy of Allah. Indeed, Allah forgives all sins. Indeed, it is He who is the Forgiving, the Merciful." (Quran 39:53)',
                                  style: Theme.of(context).textTheme.bodyMedium
                                      ?.copyWith(
                                        color: Colors.white,
                                        height: 1.6,
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: AppConstants.spacingXL),

                        // Prophet's duas
                        Text(
                          'Prophet Muhammad\'s (ﷺ) Duas for Repentance:',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacingM),

                        _buildDuaCard(
                          title: 'Dua for Seeking Forgiveness',
                          dua:
                              'اللهم أنت ربي لا إله إلا أنت، خلقتني وأنا عبدك، وأنا على عهدك ووعدك ما استطعت، أعوذ بك من شر ما صنعت، أبوء لك بنعمتك علي، وأبوء بذنبي، فاغفر لي، فإنه لا يغفر الذنوب إلا أنت.',
                          translation:
                              'O Allah, You are my Lord, none has the right to be worshipped but You. You created me and I am Your slave, and I am faithful to my covenant and my promise as far as I can. I seek refuge with You from all the evil I have done. I acknowledge Your favor upon me and I acknowledge my sin. So forgive me, for none forgives sins except You.',
                        ),

                        const SizedBox(height: AppConstants.spacingM),

                        _buildDuaCard(
                          title: 'Simple Repentance Dua',
                          dua: 'استغفر الله ربي وأتوب إليه',
                          translation:
                              'I seek forgiveness from Allah, my Lord, and I repent to Him.',
                        ),

                        const SizedBox(height: AppConstants.spacingXL),

                        // Tawbah process
                        Container(
                          padding: const EdgeInsets.all(AppConstants.spacingL),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(
                              AppConstants.radiusL,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'The Path of Tawbah:',
                                style: Theme.of(context).textTheme.titleLarge
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: AppConstants.spacingM),
                              _buildTawbahStep('1. Stop the sin immediately'),
                              _buildTawbahStep(
                                '2. Feel sincere regret for what you did',
                              ),
                              _buildTawbahStep(
                                '3. Have firm intention not to return to it',
                              ),
                              _buildTawbahStep(
                                '4. Return to Allah with sincere repentance',
                              ),
                              _buildTawbahStep(
                                '5. Do good deeds to strengthen your faith',
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // XP Award and Continue button
              Padding(
                padding: const EdgeInsets.all(AppConstants.spacingXL),
                child: Column(
                  children: [
                    // XP Award with controller integration
                    ref
                        .watch(xPControllerProvider)
                        .when(
                          loading: () => const Center(
                            child: CircularProgressIndicator(
                              color: AppConstants.primaryGreen,
                            ),
                          ),
                          error: (error, stack) => Container(
                            padding: const EdgeInsets.all(
                              AppConstants.spacingM,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusL,
                              ),
                              border: Border.all(color: AppConstants.errorRed),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.error,
                                  color: AppConstants.errorRed,
                                  size: 24,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Error loading XP',
                                  style: Theme.of(context).textTheme.titleMedium
                                      ?.copyWith(color: AppConstants.errorRed),
                                ),
                              ],
                            ),
                          ),
                          data: (xpController) => FadeTransition(
                            opacity: _fadeInAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(
                                AppConstants.spacingM,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(
                                  AppConstants.radiusL,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.2),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.add_circle,
                                    color: AppConstants.primaryGreen,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 8),
                                  Flexible(
                                    child: Text(
                                      textAlign: TextAlign.center,
                                      '+200 XP for Tawbah',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: AppConstants.primaryGreen,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    const SizedBox(height: AppConstants.spacingM),

                    // Continue button
                    FadeTransition(
                      opacity: _fadeInAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            // Navigate to appropriate next screen
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppConstants.primaryGreen,
                            padding: const EdgeInsets.symmetric(
                              vertical: AppConstants.spacingXL,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                AppConstants.radiusL,
                              ),
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: const Text(
                              textAlign: TextAlign.center,
                              'Continue with Renewed Faith',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDuaCard({
    required String title,
    required String dua,
    required String translation,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingM),
      padding: const EdgeInsets.all(AppConstants.spacingM),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Container(
            padding: const EdgeInsets.all(AppConstants.spacingS),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppConstants.radiusS),
            ),
            child: Text(
              dua,
              style: GoogleFonts.amiri(
                color: Colors.white,
                fontSize: 16,
                height: 1.6,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.right,
            ),
          ),
          const SizedBox(height: AppConstants.spacingS),
          Text(
            translation,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
              height: 1.5,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTawbahStep(String step) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingS),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                step.split('.').first,
                style: TextStyle(
                  color: AppConstants.primaryGreen,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              step.substring(step.indexOf('.') + 2),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.white.withValues(alpha: 0.9),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
