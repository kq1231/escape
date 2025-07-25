import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/chart_container.dart';

class ProgressChart extends StatelessWidget {
  final List<ProgressData> data;
  final String title;
  final String? subtitle;

  const ProgressChart({
    super.key,
    required this.data,
    this.title = 'Progress Overview',
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return ChartContainer(
      title: title,
      subtitle: subtitle,
      child: SizedBox(
        height: 200,
        child: CustomPaint(
          painter: _ProgressChartPainter(data),
          size: const Size(double.infinity, 200),
        ),
      ),
    );
  }
}

class ProgressData {
  final DateTime date;
  final double value;
  final Color? color;

  ProgressData({required this.date, required this.value, this.color});
}

class _ProgressChartPainter extends CustomPainter {
  final List<ProgressData> data;
  final Color lineColor;
  final Color fillColor;

  _ProgressChartPainter(this.data)
    : lineColor = OnboardingTheme.primaryGreen,
      fillColor = OnboardingTheme.primaryGreen.withValues(alpha: 0.1);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final fillPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = fillColor;

    // Calculate points
    final points = <Offset>[];
    final maxX = size.width;
    final maxY = size.height - 20; // Leave space for labels
    final minX = 20.0; // Leave space for Y-axis labels
    final minY = 10.0; // Leave space at top

    // Find min and max values for scaling
    double maxValue = data.map((d) => d.value).reduce((a, b) => a > b ? a : b);
    double minValue = data.map((d) => d.value).reduce((a, b) => a < b ? a : b);

    // Ensure we have some range
    if (maxValue == minValue) {
      maxValue += 1;
      minValue = minValue > 0 ? minValue - 1 : 0;
    }

    // Convert data to points
    for (int i = 0; i < data.length; i++) {
      final x = minX + (i / (data.length - 1)) * (maxX - minX - 20);
      final normalizedValue =
          (data[i].value - minValue) / (maxValue - minValue);
      final y = maxY - (normalizedValue * (maxY - minY));
      points.add(Offset(x, y));
    }

    // Draw filled area under line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, maxY); // Start at bottom
      for (int i = 0; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      path.lineTo(points[points.length - 1].dx, maxY); // End at bottom
      path.close();
      canvas.drawPath(path, fillPaint);
    }

    // Draw line
    if (points.length > 1) {
      final path = Path();
      path.moveTo(points[0].dx, points[0].dy);
      for (int i = 1; i < points.length; i++) {
        path.lineTo(points[i].dx, points[i].dy);
      }
      paint.color = lineColor;
      canvas.drawPath(path, paint);
    }

    // Draw points
    paint.style = PaintingStyle.fill;
    for (int i = 0; i < points.length; i++) {
      paint.color = data[i].color ?? lineColor;
      canvas.drawCircle(points[i], 5, paint);
    }

    // Draw Y-axis labels
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    // Max value
    textPainter.text = TextSpan(
      text: maxValue.toStringAsFixed(0),
      style: OnboardingTheme.bodySmall.copyWith(
        color: OnboardingTheme.mediumGray,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, minY - 8));

    // Min value
    textPainter.text = TextSpan(
      text: minValue.toStringAsFixed(0),
      style: OnboardingTheme.bodySmall.copyWith(
        color: OnboardingTheme.mediumGray,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, maxY - 8));

    // Draw X-axis labels (dates)
    if (data.isNotEmpty) {
      final dateFormat = TextPainter(
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      // First date
      dateFormat.text = TextSpan(
        text: '${data[0].date.day}/${data[0].date.month}',
        style: OnboardingTheme.bodySmall.copyWith(
          color: OnboardingTheme.mediumGray,
        ),
      );
      dateFormat.layout();
      dateFormat.paint(canvas, Offset(minX, maxY + 5));

      // Last date
      if (data.length > 1) {
        dateFormat.text = TextSpan(
          text: '${data.last.date.day}/${data.last.date.month}',
          style: OnboardingTheme.bodySmall.copyWith(
            color: OnboardingTheme.mediumGray,
          ),
        );
        dateFormat.layout();
        dateFormat.paint(
          canvas,
          Offset(maxX - 20 - dateFormat.width / 2, maxY + 5),
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
