import 'package:flutter/material.dart';
import 'package:escape/models/challenge_model.dart';

/// Beautiful Achievement Overlay Widget with Swipe Dismiss
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
  late AnimationController _dismissController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _dismissAnimation;
  int _currentIndex = 0;
  bool _isVisible = true;
  bool _isDismissing = false;

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
    _dismissController = AnimationController(
      duration: const Duration(milliseconds: 300),
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

    _dismissAnimation =
        Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1.2)).animate(
          CurvedAnimation(parent: _dismissController, curve: Curves.easeInBack),
        );

    // Gentle pulse effect
    _pulseController.repeat(reverse: true);
  }

  void _showNextAchievement() async {
    if (_currentIndex < widget.challenges.length && !_isDismissing) {
      // Show the current achievement
      setState(() {
        _isVisible = true;
      });

      // Slide in
      await _slideController.forward().orCancel;

      // Show for 5 seconds (unless dismissed)
      await Future.delayed(const Duration(seconds: 5));

      // Only proceed if not dismissed
      if (!_isDismissing && mounted) {
        // Slide out
        await _slideController.reverse().orCancel;

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

          if (mounted) {
            _showNextAchievement();
          }
        }
      }
    } else {
      // All achievements shown, hide overlay
      setState(() {
        _isVisible = false;
      });
    }
  }

  void _dismissCurrent() async {
    if (_isDismissing) return;

    setState(() {
      _isDismissing = true;
    });

    // Animate dismiss
    await _dismissController.forward().orCancel;

    if (mounted) {
      _dismissController.reset();
      setState(() {
        _currentIndex++;
        _isDismissing = false;
        // Hide if this was the last achievement
        if (_currentIndex >= widget.challenges.length) {
          _isVisible = false;
          return;
        }
      });

      // Reset slide controller for next achievement
      _slideController.reset();

      // Small delay before showing next achievement
      await Future.delayed(const Duration(milliseconds: 200));

      if (mounted) {
        _showNextAchievement();
      }
    }
  }

  void _dismissAll() {
    setState(() {
      _isDismissing = true;
      _isVisible = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isVisible || _currentIndex >= widget.challenges.length) {
      return const SizedBox.shrink();
    }

    final challenge = widget.challenges[_currentIndex];

    // Don't render the Dismissible if it's being dismissed
    if (_isDismissing) {
      return const SizedBox.shrink();
    }

    return SlideTransition(
      position: _dismissAnimation,
      child: SlideTransition(
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
                  child: Dismissible(
                    key: Key('achievement_${challenge.id}_$_currentIndex'),
                    direction: DismissDirection.up,
                    dismissThresholds: const {
                      DismissDirection.up: 0.3, // Easier to dismiss
                    },
                    onDismissed: (direction) {
                      // Immediately mark as dismissing to prevent rebuilds
                      setState(() {
                        _isDismissing = true;
                      });
                      // Then handle the dismissal
                      _dismissCurrent();
                    },
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
                          // Swipe indicator
                          Container(
                            width: 40,
                            height: 4,
                            margin: const EdgeInsets.only(bottom: 12),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.3),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          // Header with icon and celebration + dismiss button
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
                                      color: Colors.black.withValues(
                                        alpha: 0.15,
                                      ),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Icon(
                                  _getFeatureIcon(challenge.featureName),
                                  color: _getFeatureColor(
                                    challenge.featureName,
                                  ),
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
                              // Dismiss button
                              GestureDetector(
                                onTap: _dismissCurrent,
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    color: Colors.white.withValues(alpha: 0.2),
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 18,
                                  ),
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
                          // Footer with blessing and controls
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
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    '${_currentIndex + 1}/${widget.challenges.length}',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (widget.challenges.length > 1) ...[
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: _dismissAll,
                                      child: Text(
                                        'Skip all',
                                        style: const TextStyle(
                                          color: Colors.white70,
                                          fontSize: 12,
                                          decoration: TextDecoration.underline,
                                          decorationColor: Colors.white70,
                                        ),
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ],
                          ),
                          // Swipe hint (only show for first achievement)
                          if (_currentIndex == 0 &&
                              widget.challenges.length > 1)
                            Container(
                              margin: const EdgeInsets.only(top: 12),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.keyboard_arrow_up,
                                    color: Colors.white.withValues(alpha: 0.6),
                                    size: 16,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Swipe up to dismiss',
                                    style: TextStyle(
                                      color: Colors.white.withValues(
                                        alpha: 0.6,
                                      ),
                                      fontSize: 11,
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
              },
            ),
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
      'xp' => [
        Colors.amber.shade600,
        Colors.amber.shade700,
        Colors.yellow.shade700,
      ],
      _ => [Colors.grey.shade600, Colors.grey.shade700, Colors.grey.shade800],
    };
  }

  IconData _getFeatureIcon(String feature) {
    return switch (feature) {
      'streak' => Icons.local_fire_department,
      'prayer' => Icons.mosque,
      'temptation' => Icons.shield,
      'xp' => Icons.star,
      _ => Icons.emoji_events,
    };
  }

  Color _getFeatureColor(String feature) {
    return switch (feature) {
      'streak' => Colors.orange.shade700,
      'prayer' => Colors.blue.shade700,
      'temptation' => Colors.purple.shade700,
      'xp' => Colors.amber.shade700,
      _ => Colors.grey.shade700,
    };
  }

  @override
  void dispose() {
    _slideController.dispose();
    _pulseController.dispose();
    _dismissController.dispose();
    super.dispose();
  }
}
