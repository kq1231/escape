import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class QuickStatsCard extends StatelessWidget {
  final String title;
  final String value;
  final String? subtitle;
  final String? imageAsset;
  final Color? iconColor;
  final Color? backgroundColor;
  final Color? textColor;
  final bool isHighlighted;
  final Gradient? gradient;
  final VoidCallback? onTap;
  final bool showSparkle;
  final bool showProgress;
  final double? progressValue;

  const QuickStatsCard({
    super.key,
    required this.title,
    required this.value,
    this.subtitle,
    this.imageAsset,
    this.iconColor,
    this.backgroundColor,
    this.textColor,
    this.isHighlighted = false,
    this.gradient,
    this.onTap,
    this.showSparkle = false,
    this.showProgress = false,
    this.progressValue,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Enhanced color calculations
    final Color cardColor = backgroundColor ??
        (isDark ? const Color(0xFF1A1A1A) : Colors.white);
    
    final Color primaryTextColor = textColor ??
        (isDark ? Colors.white : const Color(0xFF1A1A1A));
    
    final Color secondaryTextColor = primaryTextColor.withOpacity(0.7);
    final Color tertiaryTextColor = primaryTextColor.withOpacity(0.5);
    
    final Color iconColorValue = iconColor ?? AppConstants.primaryGreen;
    
    // Enhanced gradient for highlighted cards
    final Gradient defaultGradient = isHighlighted
        ? LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppConstants.primaryGreen.withOpacity(0.9),
              AppConstants.lightGreen.withOpacity(0.8),
              AppConstants.primaryGreen.withOpacity(0.7),
            ],
            stops: const [0.0, 0.5, 1.0],
          )
        : LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              cardColor,
              cardColor.withOpacity(0.95),
            ],
          );

    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutQuart,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          child: Container(
            padding: const EdgeInsets.all(AppConstants.spacingM),
            decoration: BoxDecoration(
              gradient: gradient ?? defaultGradient,
              borderRadius: BorderRadius.circular(AppConstants.radiusL),
              boxShadow: isHighlighted
                  ? [
                      BoxShadow(
                        color: AppConstants.primaryGreen.withOpacity(0.4),
                        blurRadius: 25,
                        offset: const Offset(0, 10),
                        spreadRadius: 2,
                      ),
                      BoxShadow(
                        color: AppConstants.primaryGreen.withOpacity(0.2),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 15,
                        offset: const Offset(0, 6),
                        spreadRadius: 1,
                      ),
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
              border: isHighlighted
                  ? Border.all(
                      color: Colors.white.withOpacity(0.3),
                      width: 1.5,
                    )
                  : Border.all(
                      color: Colors.black.withOpacity(0.05),
                      width: 1,
                    ),
            ),
            child: Stack(
              children: [
                // Main content
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header with LARGER image and title
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageAsset != null) ...[
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            padding: const EdgeInsets.all(16), // Increased padding
                            decoration: BoxDecoration(
                              gradient: isHighlighted
                                  ? LinearGradient(
                                      colors: [
                                        Colors.white.withOpacity(0.3),
                                        Colors.white.withOpacity(0.1),
                                      ],
                                    )
                                  : LinearGradient(
                                      colors: [
                                        iconColorValue.withOpacity(0.15),
                                        iconColorValue.withOpacity(0.05),
                                      ],
                                    ),
                              shape: BoxShape.circle,
                              boxShadow: isHighlighted
                                  ? [
                                      BoxShadow(
                                        color: Colors.white.withOpacity(0.2),
                                        blurRadius: 15, // Increased blur
                                        offset: const Offset(0, 3),
                                      )
                                    ]
                                  : [
                                      BoxShadow(
                                        color: iconColorValue.withOpacity(0.1),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      )
                                    ],
                            ),
                            child: Container(
                              width: 32, // MUCH larger - from 24 to 48
                              height: 32, // MUCH larger - from 24 to 48
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                  image: AssetImage(imageAsset!),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: AppConstants.spacingS), // Increased spacing
                        ],
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8), // Added top padding for better alignment
                            child:// In QuickStatsCard, replace the Expanded title widget with this:
Expanded(
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: title.split('\n').map((line) => 
      Text(
        line,
        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
          color: isHighlighted ? Colors.white70 : secondaryTextColor,
          fontWeight: FontWeight.w700,
          fontSize: 15,
          letterSpacing: 1,
          fontFamily: 'Exo',
          height: 1.2, // Add line height for better spacing
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      )
    ).toList(),
  ),
),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppConstants.spacingL),

                    // Main value with enhanced styling
                    ShaderMask(
                      shaderCallback: (bounds) {
                        if (isHighlighted) {
                          return LinearGradient(
                            colors: [
                              Colors.white,
                              Colors.white.withOpacity(0.9),
                            ],
                          ).createShader(bounds);
                        }
                        return LinearGradient(
                          colors: [primaryTextColor, primaryTextColor],
                        ).createShader(bounds);
                      },
                      child: Text(
                        value,
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          color: isHighlighted ? Colors.white : primaryTextColor,
                          fontSize: 36,
                          
                          height: 1.0,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ),

                    if (subtitle != null) ...[
                      const SizedBox(height: AppConstants.spacingS),
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingM,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          gradient: isHighlighted
                              ? LinearGradient(
                                  colors: [
                                    Colors.white.withOpacity(0.2),
                                    Colors.white.withOpacity(0.1),
                                  ],
                                )
                              : LinearGradient(
                                  colors: [
                                    AppConstants.primaryGreen.withOpacity(0.1),
                                    AppConstants.primaryGreen.withOpacity(0.05),
                                  ],
                                ),
                          borderRadius: BorderRadius.circular(AppConstants.radiusM),
                          border: Border.all(
                            color: isHighlighted
                                ? Colors.white.withOpacity(0.3)
                                : AppConstants.primaryGreen.withOpacity(0.2),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (showProgress && progressValue != null) ...[
                              Container(
                                width: 6,
                                height: 6,
                                decoration: BoxDecoration(
                                  color: isHighlighted
                                      ? Colors.white
                                      : AppConstants.primaryGreen,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 6),
                            ],
                            Text(
                              subtitle!,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: isHighlighted ? Colors.white : tertiaryTextColor,
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    // Progress bar (optional)
                    if (showProgress && progressValue != null) ...[
                      const SizedBox(height: AppConstants.spacingM),
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: isHighlighted
                              ? Colors.white.withOpacity(0.2)
                              : Colors.black.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(2),
                        ),
                        child: AnimatedFractionallySizedBox(
                          duration: const Duration(milliseconds: 800),
                          curve: Curves.easeOutCubic,
                          alignment: Alignment.centerLeft,
                          widthFactor: progressValue!.clamp(0.0, 1.0),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: isHighlighted
                                    ? [Colors.white, Colors.white70]
                                    : [
                                        AppConstants.primaryGreen,
                                        AppConstants.lightGreen,
                                      ],
                              ),
                              borderRadius: BorderRadius.circular(2),
                              boxShadow: [
                                BoxShadow(
                                  color: (isHighlighted ? Colors.white : AppConstants.primaryGreen)
                                      .withOpacity(0.4),
                                  blurRadius: 4,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),

                // Enhanced decorative elements
                if (isHighlighted) ...[
                  // Top right glow
                  Positioned(
                    top: -20,
                    right: -20,
                    child: Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.15),
                            Colors.transparent,
                          ],
                          stops: const [0.1, 0.8],
                        ),
                      ),
                    ),
                  ),
                  
                  // Bottom left glow
                  Positioned(
                    bottom: -15,
                    left: -15,
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: RadialGradient(
                          colors: [
                            Colors.white.withOpacity(0.1),
                            Colors.transparent,
                          ],
                          stops: const [0.1, 0.7],
                        ),
                      ),
                    ),
                  ),
                ],

                // Sparkle effect (optional)
                if (showSparkle && isHighlighted) ...[
                  Positioned(
                    top: 10,
                    right: 10,
                    child: _SparkleIcon(),
                  ),
                ],

                // Hover/tap overlay
                if (onTap != null)
                  Positioned.fill(
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        borderRadius: BorderRadius.circular(AppConstants.radiusL),
                        onTap: null, // Already handled by parent
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(AppConstants.radiusL),
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.white.withOpacity(0.1),
                                Colors.transparent,
                                Colors.black.withOpacity(0.02),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Sparkle effect widget
class _SparkleIcon extends StatefulWidget {
  @override
  __SparkleIconState createState() => __SparkleIconState();
}

class __SparkleIconState extends State<_SparkleIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotation;
  late Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _rotation = Tween<double>(begin: 0, end: 2 * 3.14159).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scale = TweenSequence<double>([
      TweenSequenceItem(tween: Tween<double>(begin: 0.8, end: 1.2), weight: 1),
      TweenSequenceItem(tween: Tween<double>(begin: 1.2, end: 0.8), weight: 1),
    ]).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
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
        return Transform.rotate(
          angle: _rotation.value,
          child: Transform.scale(
            scale: _scale.value,
            child: Icon(
              Icons.star_rounded,
              color: Colors.white,
              size: 20, // Slightly larger sparkle
              shadows: [
                Shadow(
                  color: Colors.white.withOpacity(0.8),
                  blurRadius: 10, // Increased blur
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}