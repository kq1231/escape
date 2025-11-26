import 'package:flutter/material.dart';


class LiquidBorderPainter extends CustomPainter {
  final Animation<double> animation;
  final Color? backgroundColor;

  LiquidBorderPainter({
    required this.animation,
    this.backgroundColor,
  }) : super(repaint: animation);

  @override
  void paint(Canvas canvas, Size size) {
    const borderWidth = 4.0;
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    const radius = 24.0;

    final rRect = RRect.fromRectAndRadius(rect, const Radius.circular(radius));

    if (backgroundColor != null) {
      final fillPaint = Paint()
        ..style = PaintingStyle.fill
        ..color = backgroundColor!;
      canvas.drawRRect(rRect, fillPaint);
    }

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth
      ..shader = SweepGradient(
        startAngle: 0.0,
        endAngle: 6.28,
        tileMode: TileMode.repeated,
colors: [
  Colors.transparent,
  const Color(0xFFB2F2BB), // pastel green
  const Color(0xFFD3F9D8), // light mint
  const Color(0xFFB2F2BB), // repeat
  Colors.transparent,
],
        stops: [
          (animation.value - 0.15).clamp(0.0, 1.0),
          (animation.value - 0.05).clamp(0.0, 1.0),
          animation.value,
          (animation.value + 0.05).clamp(0.0, 1.0),
          (animation.value + 0.15).clamp(0.0, 1.0),
        ],
        transform: GradientRotation(animation.value * 6.28),
      ).createShader(rect);

    canvas.drawRRect(rRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
