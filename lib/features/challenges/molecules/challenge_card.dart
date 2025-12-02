import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';
import '../../../widgets/xp_badge.dart';
import '../atoms/challenge_badge.dart';
import '../atoms/progress_bar.dart';

class ChallengeCard extends StatefulWidget {
  final String title;
  final String description;
  final double progress;
  final double rating;
  final int maxRating;
  final bool isCompleted;
  final String? difficulty;
  final Color? difficultyColor;
  final int? xp;
  final VoidCallback? onTap;
  final Widget? leadingWidget;
  final List<Widget>? trailingWidgets;

  const ChallengeCard({
    super.key,
    required this.title,
    required this.description,
    this.progress = 0.0,
    this.rating = 0.0,
    this.maxRating = 5,
    this.isCompleted = false,
    this.difficulty,
    this.difficultyColor,
    this.xp,
    this.onTap,
    this.leadingWidget,
    this.trailingWidgets,
  });

  @override
  State<ChallengeCard> createState() => _ChallengeCardState();
}

class _ChallengeCardState extends State<ChallengeCard> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _progressAnimation;
  late Animation<Color?> _colorAnimation;
  late Animation<double> _glowAnimation;
  late AnimationController _floatController;
  late Animation<double> _floatAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: const Duration(milliseconds: 800), vsync: this);

    _floatController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this)
      ..repeat(reverse: true); // Boucle infinie de flottement

    _scaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    _progressAnimation = Tween<double>(
      begin: 0.0,
      end: widget.progress,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: widget.isCompleted ? AppConstants.successGreen.withOpacity(0.1) : Colors.transparent,
    ).animate(_controller);

    _glowAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));

    _floatAnimation = Tween<double>(
      begin: -5.0,
      end: 5.0,
    ).animate(CurvedAnimation(parent: _floatController, curve: Curves.easeInOut));

    _controller.forward();
  }

  @override
  void didUpdateWidget(covariant ChallengeCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.progress != oldWidget.progress || widget.isCompleted != oldWidget.isCompleted) {
      _progressAnimation = Tween<double>(
        begin: oldWidget.progress,
        end: widget.progress,
      ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _floatController.dispose();
    super.dispose();
  }

  Color _getStatusColor() {
    if (widget.isCompleted) {
      return AppConstants.successGreen;
    } else if (widget.progress > 0) {
      return AppConstants.warningOrange;
    } else {
      return AppConstants.mediumGray;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor();
    final bool showXpBadge = widget.xp != null && widget.xp! > 0;

    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        _controller.reverse();
      },
      onTapCancel: () {
        _controller.forward();
      },
      onTapUp: (_) {
        _controller.forward();
      },
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(scale: _scaleAnimation.value, child: child);
        },
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 12, offset: const Offset(0, 6))],
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.surface,
                      Theme.of(context).colorScheme.surface.withOpacity(0.9),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statusColor.withOpacity(0.2), width: 1.5),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: widget.onTap,
                    child: Container(
                      height: 320,
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          if (widget.leadingWidget != null)
                            AnimatedBuilder(
                              animation: _floatController,
                              builder: (context, child) {
                                return Transform.translate(offset: Offset(0, _floatAnimation.value), child: child);
                              },
                              child: Center(child: widget.leadingWidget!),
                            ),

                          const SizedBox(height: 6),

                          Container(
                            width: double.infinity,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Flexible(
                                  child: Text(
                                    widget.title,
                                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                      color: widget.isCompleted
                                          ? AppConstants.successGreen
                                          : Theme.of(context).colorScheme.onSurface,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                      fontFamily: 'Exo',
                                    ),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (widget.isCompleted)
                                  Image.asset(
                                    'assets/checked.png',
                                    width: 18,
                                    height: 18,
                                    color: AppConstants.successGreen,
                                  ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            widget.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                              fontSize: 14,
                              fontFamily: 'Exo',
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),

                          const SizedBox(height: 12),
                          if (widget.xp != null && widget.xp! > 0)
                            Center(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(Icons.star_rounded, color: Theme.of(context).colorScheme.primary, size: 14),
                                    const SizedBox(width: 4),
                                    Text(
                                      '+${widget.xp} XP',
                                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 11,
                                        fontFamily: 'Exo',
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          const Spacer(),

                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: TweenAnimationBuilder<double>(
                                      tween: Tween<double>(begin: 0, end: widget.progress),
                                      duration: const Duration(milliseconds: 1000),
                                      curve: Curves.easeOutCubic,
                                      builder: (context, value, _) {
                                        return ChallengeProgressBar(
                                          progress: value,
                                          backgroundColor: Theme.of(context).colorScheme.surfaceVariant,
                                          progressColor: statusColor,
                                          height: 5,
                                        );
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    '${(widget.progress * 100).round()}%',
                                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: statusColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              if (showXpBadge)
                Positioned(
                  top: -10,
                  right: -8,
                  child: ScaleTransition(
                    scale: Tween<double>(
                      begin: 0.0,
                      end: 1.0,
                    ).animate(CurvedAnimation(parent: _controller, curve: Curves.elasticOut)),
                    child: XPBadge(
                      backgroundColor: widget.isCompleted
                          ? AppConstants.successGreen
                          : Theme.of(context).colorScheme.primary,
                      textColor: Colors.white,
                      xpAmount: widget.xp!,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
