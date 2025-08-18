import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class LustCycleDiagram extends StatelessWidget {
  final double? width;
  final double? height;

  const LustCycleDiagram({super.key, this.width, this.height});

  // Helper method to get appropriate text color for dark mode
  Color _getTextColor(BuildContext context, Color defaultColor) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark ? Colors.white : defaultColor;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: const EdgeInsets.all(AppTheme.spacingXL),
      decoration: BoxDecoration(
        color: AppTheme.lightGreen.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusL),
        border: Border.all(
          color: AppTheme.primaryGreen.withValues(alpha: 0.3),
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
            width: 250,
            height: 200,
            child: CustomPaint(painter: _LustCyclePainter()),
          ),
          const SizedBox(height: AppTheme.spacingL),
          // Cycle explanation
          Text(
            'Lust cycles typically peak within 15-30 minutes and then naturally decline if not fed.',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: _getTextColor(context, AppTheme.darkGreen),
              fontSize: 16,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
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
              'Key Insight: If you can resist for 30 minutes, the urge will significantly decrease.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(context, AppTheme.primaryGreen),
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
              textAlign: TextAlign.center,
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

    // Draw the cycle curve
    final path = Path();
    final startX = size.width * 0.1;
    final endX = size.width * 0.9;
    final peakY = size.height * 0.2;
    final baseY = size.height * 0.8;

    // Start from left base
    path.moveTo(startX, baseY);

    // Curve up to peak
    path.quadraticBezierTo(size.width * 0.3, peakY, size.width * 0.5, peakY);

    // Curve down to right base
    path.quadraticBezierTo(size.width * 0.7, peakY, endX, baseY);

    canvas.drawPath(path, paint);

    // Draw peak indicator
    final peakPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = AppTheme.errorRed;

    canvas.drawCircle(Offset(size.width * 0.5, peakY), 8, peakPaint);

    // Draw peak label
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'Peak\n(15-30 min)',
        style: TextStyle(
          color: AppTheme.errorRed,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(size.width * 0.5 - textPainter.width / 2, peakY - 40),
    );

    // Draw time markers
    _drawTimeMarker(canvas, size, '0 min', startX, baseY);
    _drawTimeMarker(canvas, size, '15 min', size.width * 0.3, baseY);
    _drawTimeMarker(canvas, size, '30 min', size.width * 0.5, baseY);
    _drawTimeMarker(canvas, size, '45 min', size.width * 0.7, baseY);
    _drawTimeMarker(canvas, size, '60+ min', endX, baseY);

    // Draw intensity labels
    _drawIntensityLabel(canvas, size, 'High', size.width * 0.5, peakY - 20);
    _drawIntensityLabel(canvas, size, 'Low', startX, baseY + 20);
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

  void _drawIntensityLabel(
    Canvas canvas,
    Size size,
    String text,
    double x,
    double y,
  ) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: AppTheme.mediumGray,
          fontSize: 10,
          fontWeight: FontWeight.w500,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(x - textPainter.width / 2, y));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
