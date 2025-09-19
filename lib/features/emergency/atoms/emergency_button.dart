import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class EmergencyButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

  const EmergencyButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.backgroundColor,
    this.foregroundColor,
    this.width,
    this.height,
    this.padding,
  });

  @override
  State<EmergencyButton> createState() => _EmergencyButtonState();
}

class _EmergencyButtonState extends State<EmergencyButton>
    with TickerProviderStateMixin {
  late AnimationController _gradientController;
  late AnimationController _borderController;
  late Animation<double> _gradientAnimation;
  late Animation<double> _borderAnimation;

  @override
  void initState() {
    super.initState();

    // Animation for the inner gradient
    _gradientController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );

    // Animation for the border gradient
    _borderController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );

    _gradientAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _gradientController, curve: Curves.easeInOut),
    );

    _borderAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _borderController, curve: Curves.easeInOut),
    );

    // Start the animations and repeat them
    _gradientController.repeat(reverse: true);
    _borderController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _gradientController.dispose();
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_gradientAnimation, _borderAnimation]),
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height ?? 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppConstants.radiusL),
            // Animated gradient border
            gradient: LinearGradient(
              colors: [
                Colors.purple.withValues(alpha: 0.8),
                Colors.blue.withValues(alpha: 0.8),
                Colors.indigo.withValues(alpha: 0.8),
                Colors.purple.withValues(alpha: 0.8),
              ],
              stops: [
                (_borderAnimation.value - 0.3).clamp(0.0, 1.0),
                (_borderAnimation.value - 0.1).clamp(0.0, 1.0),
                (_borderAnimation.value + 0.1).clamp(0.0, 1.0),
                (_borderAnimation.value + 0.3).clamp(0.0, 1.0),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Container(
            margin: const EdgeInsets.all(3), // Border thickness
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppConstants.radiusL - 3),
              // Animated inner gradient
              gradient: LinearGradient(
                colors: [
                  Colors.orange.withValues(alpha: 0.9),
                  Colors.red.withValues(alpha: 0.8),
                  Colors.yellow.withValues(alpha: 0.9),
                  Colors.orange.withValues(alpha: 0.9),
                ],
                stops: [
                  (_gradientAnimation.value - 0.2).clamp(0.0, 1.0),
                  _gradientAnimation.value.clamp(0.0, 1.0),
                  (_gradientAnimation.value + 0.2).clamp(0.0, 1.0),
                  (_gradientAnimation.value + 0.4).clamp(0.0, 1.0),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withValues(alpha: 0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
                BoxShadow(
                  color: Colors.red.withValues(alpha: 0.2),
                  blurRadius: 25,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.onPressed,
                borderRadius: BorderRadius.circular(AppConstants.radiusL - 3),
                child: Container(
                  padding:
                      widget.padding ??
                      const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXL,
                        vertical: AppConstants.spacingM,
                      ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (widget.icon != null) ...[
                        Icon(
                          widget.icon,
                          size: 24,
                          color: Colors.white,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                        const SizedBox(width: AppConstants.spacingS),
                      ],
                      Text(
                        widget.text,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 18,
                          shadows: [
                            Shadow(
                              color: Colors.black.withValues(alpha: 0.5),
                              offset: const Offset(1, 1),
                              blurRadius: 2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
