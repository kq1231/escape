import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class LustCycleDiagram extends StatelessWidget {
  final double? width;
  final double? height;

  const LustCycleDiagram({super.key, this.width, this.height});

  // Helper method to get appropriate text color for dark mode
  Color _getTextColor(BuildContext context, Color defaultColor) {
    return Theme.of(context).brightness == Brightness.dark
        ? Colors.white70
        : defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: Theme.of(context).brightness == Brightness.dark
            ? AppTheme.primaryGreen.withValues(alpha: 0.05)
            : AppTheme.lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: Theme.of(context).brightness == Brightness.dark
              ? Colors.white.withValues(alpha: 0.2)
              : AppTheme.primaryGreen.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'The Lust Cycle',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: _getTextColor(context, AppTheme.darkGreen),
              fontSize: 22,
            ),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Cycle diagram
          SizedBox(
            width: 400,
            height: 200,
            child: CustomPaint(painter: _LustCyclePainter()),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Cycle explanation
          Text(
            'Lust cycles peak quickly (often within 5-10 minutes) and then gradually decline over 30 minutes.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _getTextColor(context, AppTheme.darkGreen),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Skewness explanation
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingS),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.primaryGreen.withValues(alpha: 0.05)
                  : AppTheme.lightGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Text(
              'Why left-skewed? Triggers make intensity spike early, but it takes time for the urge to fully disappear.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: _getTextColor(context, AppTheme.darkGreen),
                fontSize: 14,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Key insight
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
            ),
            child: Text(
              'Key Insight: If you can resist for just 30 minutes, the urge will be DESTROYED Insha\'Allah.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(context, AppTheme.primaryGreen),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: AppTheme.spacingM),
          // Improvement motivation
          Container(
            padding: const EdgeInsets.all(AppTheme.spacingM),
            decoration: BoxDecoration(
              color: Theme.of(context).brightness == Brightness.dark
                  ? AppTheme.primaryGreen.withValues(alpha: 0.08)
                  : AppTheme.primaryGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(AppTheme.radiusM),
              border: Border.all(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.white.withValues(alpha: 0.2)
                    : AppTheme.primaryGreen.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: Column(
              children: [
                Text(
                  'The Power of Practice',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getTextColor(context, AppTheme.primaryGreen),
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppTheme.spacingS),
                Text(
                  'Every time you overcome temptation, this graph will SHRINK! Time, intensity, and frequency will decrease exponentially. Just a few victories will make a massive difference.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: _getTextColor(context, AppTheme.darkGreen),
                    fontSize: 13,
                    height: 1.4,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LustCyclePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..color = AppTheme.primaryGreen;

    // Draw the cycle curve (left-skewed bell curve)
    final path = Path();
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;
    final peakY = size.height * 0.2;
    final baseY = size.height * 0.8;

    // Start from left base
    path.moveTo(startX, baseY);

    // Create left-skewed bell curve using cubic bezier
    // Peak at around 7 minutes (left side)
    final controlPoint1X = size.width * 0.25; // Peak around 7 min
    final controlPoint1Y = peakY;
    final controlPoint2X = size.width * 0.4; // Quick descent
    final controlPoint2Y = size.height * 0.5;

    // Curve up quickly to early peak, then gradual decline
    path.cubicTo(
      controlPoint1X,
      controlPoint1Y,
      controlPoint2X,
      controlPoint2Y,
      size.width * 0.6,
      size.height * 0.6, // Middle point
    );

    // Continue gradual decline to end
    path.cubicTo(
      size.width * 0.75,
      size.height * 0.7,
      size.width * 0.85,
      size.height * 0.75,
      endX,
      baseY,
    );

    canvas.drawPath(path, paint);

    // Draw time markers (only 0-30 minutes)
    _drawTimeMarker(canvas, size, '0 min', startX, baseY);
    _drawTimeMarker(canvas, size, '5 min', size.width * 0.2, baseY);
    _drawTimeMarker(canvas, size, '10 min', size.width * 0.35, baseY);
    _drawTimeMarker(canvas, size, '20 min', size.width * 0.55, baseY);
    _drawTimeMarker(canvas, size, '30 min', endX, baseY);
  }

  void _drawTimeMarker(
    Canvas canvas,
    Size size,
    String text,
    double x,
    double y,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(color: AppTheme.mediumGray, fontSize: 10),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y + 10));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
