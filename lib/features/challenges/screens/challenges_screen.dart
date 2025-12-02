import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import '../molecules/challenge_card.dart';
import '../../../providers/challenges_provider.dart';

class ChallengesScreen extends ConsumerStatefulWidget {
  const ChallengesScreen({super.key});

  @override
  ConsumerState<ChallengesScreen> createState() => _ChallengesScreenState();
}

class _ChallengesScreenState extends ConsumerState<ChallengesScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late Animation<double> _headerAnimation;

  String _getXpBadgePath(String title) {
    switch (title.toLowerCase()) {
      case 'novice':
        return 'assets/icons/novice_badge.png';
      case 'warrior':
        return 'assets/icons/warrior_badge.png';
      case 'champion':
        return 'assets/icons/champion_badge.png';
      case 'master':
        return 'assets/icons/master_badge.png';
      case 'legend':
        return 'assets/icons/legend_badge.png';
      case 'hero':
        return 'assets/icons/hero_badge.png';
      case 'grandmaster':
        return 'assets/icons/grandmaster_badge.png';
      case 'awesome':
        return 'assets/icons/awesome_badge.png';
      default:
        return 'assets/icons/novice_badge.png';
    }
  }

  IconData _getFeatureIcon(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'streak':
        return Icons.trending_up;
      case 'prayer':
        return Icons.self_improvement;
      case 'temptation':
        return Icons.psychology;
      case 'meditation':
        return Icons.mood;
      case 'reading':
        return Icons.book;
      case 'xp':
        return Icons.star;
      default:
        return Icons.star;
    }
  }

  String _getDifficultyText(int xp) {
    if (xp <= 50) return 'Easy';
    if (xp <= 100) return 'Med';
    return 'Hard';
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return Colors.green;
      case 'med':
        return Colors.orange;
      case 'hard':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  void initState() {
    super.initState();
    _headerController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutCubic,
    );
    _headerController.forward();
  }

  @override
  void dispose() {
    _headerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final challengesAsync = ref.watch(challengesProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: challengesAsync.when(
        loading: () => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Theme.of(context).colorScheme.primary,
                ),
                strokeWidth: 3,
              ),
              const SizedBox(height: 16),
              Text(
                'Loading Challenges...',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                    ),
              ),
            ],
          ),
        ),
        error: (error, stack) => Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline,
                  size: 80,
                  color: Theme.of(context).colorScheme.error,
                ),
                const SizedBox(height: 20),
                Text(
                  'Oops! Something went wrong',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Error: $error',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onBackground.withOpacity(0.6),
                      ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => ref.refresh(challengesProvider),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Try Again'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        data: (challenges) {
          final xpChallenges =
              challenges.where((c) => c.featureName == 'xp').toList();
          final regularChallenges =
              challenges.where((c) => c.featureName != 'xp').toList();
      
          return Column(
            children: [
              FadeTransition(
                opacity: _headerAnimation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, -0.5),
                    end: Offset.zero,
                  ).animate(_headerAnimation),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.only(top: 60, bottom: 24, left: 24, right: 24),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Theme.of(context).colorScheme.primary,
                          Theme.of(context).colorScheme.primaryContainer,
                          Theme.of(context).colorScheme.secondaryContainer,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        stops: const [0.0, 0.6, 1.0],
                      ),
                      borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(32),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                           Image.asset( 'assets/icons/trophy_icon.png',
                              width: 40,
                              height: 40,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Challenges',
                                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 32,fontFamily: 'Exo',
                                    ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Complete challenges and earn amazing rewards!',
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.9),
                                fontSize: 16,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.star_rounded,
                                color: Colors.amber,
                                size: 20,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                '${challenges.where((c) => c.isCompleted).length}/${challenges.length} Completed',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onPrimary,
                                      fontWeight: FontWeight.w600,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      
              // Scrollable content
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 24),
      
                      // XP Challenges Section
                      if (xpChallenges.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 16),
                          padding: const EdgeInsets.all(20),
                         
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.amber.withOpacity(0.2),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      color: Colors.amber.shade700,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'XP Milestones',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          color: Colors.amber.shade800,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 28),
                              SizedBox(
                                height: 320,
                                child: PageView.builder(
                                  controller: PageController(viewportFraction: 0.75),
                                  itemCount: xpChallenges.length,
                                  itemBuilder: (context, index) {
                                    final challenge = xpChallenges[index];
                                    return Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 8),
                                      child: AnimatedCardWidget(
                                        child: ChallengeCard(
                                          title: challenge.title,
                                          description: challenge.description,
                                          progress: challenge.isCompleted ? 1.0 : 0.0,
                                          rating: 0.0,
                                          difficulty: _getDifficultyText(challenge.xp),
                                          difficultyColor: _getDifficultyColor(_getDifficultyText(challenge.xp)),
                                          xp: challenge.xp,
                                          isCompleted: challenge.isCompleted,
                                          leadingWidget: Hero(
                                            tag: 'badge-${challenge.title}',
                                            child: FloatingBadgeAnimation(
                                              isCompleted: challenge.isCompleted,
                                              child: Image.asset(
                                                _getXpBadgePath(challenge.title),
                                                width: 170, // Much larger badge
                                                height: 170,
                                                fit: BoxFit.contain,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
      
                      const SizedBox(height: 24),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.list_alt_rounded,
                                    color: Theme.of(context).colorScheme.primary,
                                    size: 28,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'Activity Challenges',
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                'Daily challenges to build positive habits',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: Theme.of(context).colorScheme.onBackground.withOpacity(0.7),
                                    ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            LayoutBuilder(
                              builder: (context, constraints) {
                                final isTablet = constraints.maxWidth > 600;
                                final maxCrossAxisExtent = isTablet
                                    ? constraints.maxWidth / 2
                                    : constraints.maxWidth;
                                
                                return AnimationLimiter(
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                                      maxCrossAxisExtent: maxCrossAxisExtent,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      mainAxisExtent: 240, // Increased height for larger badges
                                      childAspectRatio: 1.6,
                                    ),
                                    itemCount: regularChallenges.length,
                                    itemBuilder: (context, index) {
                                      final challenge = regularChallenges[index];
                                      final difficulty = _getDifficultyText(challenge.xp);
                                      
                                      return AnimationConfiguration.staggeredGrid(
                                        position: index,
                                        duration: const Duration(milliseconds: 600),
                                        columnCount: isTablet ? 2 : 1,
                                        child: SlideAnimation(
                                          verticalOffset: 50.0,
                                          child: FadeInAnimation(
                                            child: ChallengeCard(
                                              title: challenge.title,
                                              description: challenge.description,
                                              progress: challenge.isCompleted ? 1.0 : 0.0,
                                              rating: 0.0,
                                              difficulty: difficulty,
                                              difficultyColor: _getDifficultyColor(difficulty),
                                              xp: challenge.xp,
                                              isCompleted: challenge.isCompleted,
                                              leadingWidget: FeatureIconWidget(
                                                featureName: challenge.featureName,
                                                isCompleted: challenge.isCompleted,
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// Feature Icon Widget
class FeatureIconWidget extends StatelessWidget {
  final String featureName;
  final bool isCompleted;

  const FeatureIconWidget({
    super.key,
    required this.featureName,
    required this.isCompleted,
  });

  IconData _getFeatureIcon(String featureName) {
    switch (featureName.toLowerCase()) {
      case 'streak':
        return Icons.trending_up_rounded;
      case 'prayer':
        return Icons.self_improvement_rounded;
      case 'temptation':
        return Icons.psychology_rounded;
      case 'meditation':
        return Icons.mood_rounded;
      case 'reading':
        return Icons.menu_book_rounded;
      case 'xp':
        return Icons.star_rounded;
      default:
        return Icons.star_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70, // Larger icon container
      height: 70,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isCompleted
              ? [
                  Theme.of(context).colorScheme.primary,
                  Theme.of(context).colorScheme.secondary,
                ]
              : [
                  Theme.of(context).colorScheme.surfaceVariant,
                  Theme.of(context).colorScheme.surfaceVariant.withOpacity(0.7),
                ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withOpacity(isCompleted ? 0.3 : 0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Icon(
        _getFeatureIcon(featureName),
        color: isCompleted
            ? Theme.of(context).colorScheme.onPrimary
            : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 32, // Larger icon
      ),
    );
  }
}

// Floating Badge Animation Widget with infinite floating effect
class FloatingBadgeAnimation extends StatefulWidget {
  final Widget child;
  final bool isCompleted;

  const FloatingBadgeAnimation({
    super.key,
    required this.child,
    required this.isCompleted,
  });

  @override
  State<FloatingBadgeAnimation> createState() => _FloatingBadgeAnimationState();
}

class _FloatingBadgeAnimationState extends State<FloatingBadgeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    )..repeat(reverse: true); // Infinite floating animation
    
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticOut),
      ),
    );
    
    _rotationAnimation = Tween<double>(begin: -0.1, end: 0.1).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
    
    _floatAnimation = Tween<double>(begin: -10.0, end: 10.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.isCompleted) {
      _controller.forward();
    } else {
      _controller.value = 0.3; // Start at scaled state without floating
    }
  }

  @override
  void didUpdateWidget(covariant FloatingBadgeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isCompleted && !oldWidget.isCompleted) {
      _controller.repeat(reverse: true); // Start infinite floating
    } else if (!widget.isCompleted && oldWidget.isCompleted) {
      _controller.stop();
      _controller.value = 0.3;
    }
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
        return Transform.translate(
          offset: Offset(0, _floatAnimation.value),
          child: Transform.rotate(
            angle: _rotationAnimation.value,
            child: Transform.scale(
              scale: _scaleAnimation.value,
              child: child,
            ),
          ),
        );
      },
      child: widget.child,
    );
  }
}

// Animated card helper
class AnimatedCardWidget extends StatefulWidget {
  final Widget child;

  const AnimatedCardWidget({required this.child, super.key});

  @override
  State<AnimatedCardWidget> createState() => _AnimatedCardWidgetState();
}

class _AnimatedCardWidgetState extends State<AnimatedCardWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutBack,
      ),
    );
    
    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeIn,
      ),
    );

    _controller.forward();
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
        return Opacity(
          opacity: _opacityAnimation.value,
          child: Transform.scale(
            scale: _scaleAnimation.value,
            child: child,
          ),
        );
      },
      child: widget.child,
    );
  }
}