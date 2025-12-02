import 'package:escape/providers/has_active_temptation_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:escape/theme/app_constants.dart';
import '../features/streak/organisms/streak_organism.dart';
import '../features/temptation/screens/temptation_flow_screen.dart';
import '../features/history/screens/temptation_history_screen.dart';
import '../features/analytics/organisms/quick_stats_organism.dart';
import 'package:escape/providers/prayer_provider.dart';
import 'package:escape/providers/prayer_timing_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with SingleTickerProviderStateMixin {
  final bool _isEmergencyButtonEnabled = true;
  late AnimationController _iconAnimationController;
  late Animation<double> _iconScaleAnimation;

  @override
  void initState() {
    super.initState();
    _iconAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _iconScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 1.0, end: 1.1), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.1, end: 1.0), weight: 1),
    ]).animate(
      CurvedAnimation(
        parent: _iconAnimationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _iconAnimationController.dispose();
    super.dispose();
  }

  void _onEmergencyButtonPressed(BuildContext context) {
    if (_isEmergencyButtonEnabled) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const TemptationFlowScreen()),
      );
    }
  }

  void _onHistoryButtonPressed(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TemptationHistoryScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final hasActiveTemptation = ref.watch(hasActiveTemptationProvider);
    final todaysPrayersAsync = ref.watch(todaysPrayersProvider());
    ref.watch(prayerTimingProvider);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasActiveTemptation) ...[
                _buildActiveTemptationBanner(context),
                const SizedBox(height: AppConstants.spacingXL),
              ],

              StreakOrganism(labelText: 'Days Clean', isActive: true),
              const SizedBox(height: AppConstants.spacingXL),

              todaysPrayersAsync.when(
                data: (prayers) {
                  final int total = 6; 
                  final int completed =
                      prayers.where((p) => p.isCompleted).length;
                  final double percentage =
                      total > 0 ? completed / total : 0.0;

                  return Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingS,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(AppConstants.radiusXXL),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Left side (Green card with text)
                        Container(
                          height: 120,
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: AppConstants.primaryGreen,
                            borderRadius:
                                BorderRadius.circular(AppConstants.radiusXL),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Today's Prayers",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: 'Exo',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                '$completed / $total Completed',
                                style: const TextStyle(
                                  fontFamily: 'Exo',
                                  fontSize: 16,
                                  color: Colors.white70,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Right side (Circular Progress)
                        Padding(
                          padding: const EdgeInsets.only(right: 16.0),
                          child: CircularPercentIndicator(
                            radius: 65,
                            lineWidth: 12,
                            percent: percentage.clamp(0.0, 1.0),
                            backgroundColor: Colors.grey.shade200,
                            progressColor: AppConstants.primaryGreen,
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '$completed/$total',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Exo',
                                color: AppConstants.primaryGreen,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                error: (e, _) => _buildErrorCard(),
                loading: () => _buildLoadingCard(),
              ),

              const SizedBox(height: AppConstants.spacingXL),

              // Emergency Button
              _buildActionRow(context),

              const SizedBox(height: AppConstants.spacingXL),

              // Quick Stats
              QuickStatsOrganism(),
            ],
          ),
        ),
      ),
    );
  }

  // Helper Widgets

  Widget _buildActiveTemptationBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingL),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppConstants.errorRed.withOpacity(0.15),
            AppConstants.errorRed.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppConstants.radiusXL),
        border: Border.all(
          color: AppConstants.errorRed.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppConstants.errorRed.withOpacity(0.1),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppConstants.errorRed.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: AppConstants.errorRed,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingM),
              Expanded(
                child: Text(
                  'Active Temptation Session',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppConstants.errorRed,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppConstants.spacingM),
          Text(
            'You have an ongoing temptation session. Tap below to continue your journey.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppConstants.darkGray,
                ),
          ),
          const SizedBox(height: AppConstants.spacingL),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const TemptationFlowScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppConstants.errorRed,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text(
                'Continue Session',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorCard() => Container(
        padding: const EdgeInsets.all(AppConstants.spacingL),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
        ),
        child: const Text('Error loading prayer data'),
      );

  Widget _buildLoadingCard() => Container(
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusXXL),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: const Center(
          child: CircularProgressIndicator(color: AppConstants.primaryGreen),
        ),
      );

  Widget _buildActionRow(BuildContext context) => Row(
        children: [
          Expanded(
            flex: 3,
            child: Container(
              height: 70,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppConstants.primaryGreen,
                    AppConstants.primaryGreen.withOpacity(0.8),
                    AppConstants.lightGreen,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: const [0.0, 0.5, 1.0],
                ),
                borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                boxShadow: [
                  BoxShadow(
                    color: AppConstants.primaryGreen.withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppConstants.primaryGreen.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () => _onEmergencyButtonPressed(context),
                  borderRadius: BorderRadius.circular(AppConstants.radiusXL),
                  highlightColor: Colors.white.withOpacity(0.2),
                  splashColor: Colors.white.withOpacity(0.3),
                  child: Stack(
                    children: [
                      // Pulsing animation effect
                    
                      
                      // Main content
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Animated icon
                          ScaleTransition(
                            scale: _iconScaleAnimation,
                            child: Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.emergency_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingM),
                          
                          // Text with better styling
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'I Need Help',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'Exo',
                                  shadows: [
                                    Shadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                              ),
                             
                            ],
                          ),
                        ],
                      ),
                      
                      // Top right decorative element
                      Positioned(
                        top: 8,
                        right: 12,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.6),
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      );
}

// Pulsing animation widget
class _PulseAnimation extends StatefulWidget {
  @override
  __PulseAnimationState createState() => __PulseAnimationState();
}

class __PulseAnimationState extends State<_PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _opacity = Tween<double>(
      begin: 0.3,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: RadialGradient(
              colors: [
                Colors.white.withOpacity(_opacity.value),
                Colors.transparent,
              ],
              stops: const [0.1, 0.8],
            ),
            borderRadius: BorderRadius.circular(AppConstants.radiusXL),
          ),
        );
      },
    );
  }
}