import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';
import '../atoms/chart_container.dart';

class StreakGraph extends StatelessWidget {
  final List<StreakData> data;
  final String title;
  final String? subtitle;

  const StreakGraph({
    super.key,
    required this.data,
    this.title = 'Streak History',
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
          painter: _StreakGraphPainter(data),
          size: const Size(double.infinity, 200),
        ),
      ),
    );
  }
}

class StreakData {
  final DateTime date;
  final int streakCount;
  final bool isActive;

  StreakData({
    required this.date,
    required this.streakCount,
    this.isActive = true,
  });
}

class _StreakGraphPainter extends CustomPainter {
  final List<StreakData> data;
  final Color activeColor;
  final Color inactiveColor;

  _StreakGraphPainter(this.data)
    : activeColor = OnboardingTheme.primaryGreen,
      inactiveColor = OnboardingTheme.mediumGray;

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..strokeWidth = 20
      ..strokeCap = StrokeCap.round;

    final maxX = size.width - 20; // Leave space for labels
    final maxY = size.height - 30; // Leave space for labels
    final minX = 20.0; // Leave space for Y-axis labels
    final minY = 20.0; // Leave space at top

    // Find max streak for scaling
    int maxStreak = data
        .map((d) => d.streakCount)
        .reduce((a, b) => a > b ? a : b);

    // Ensure we have some range
    if (maxStreak == 0) maxStreak = 1;

    // Draw bars
    final barWidth = (maxX - minX - (data.length - 1) * 10) / data.length;

    for (int i = 0; i < data.length; i++) {
      final x = minX + i * (barWidth + 10);
      final normalizedValue = data[i].streakCount / maxStreak;
      final barHeight = normalizedValue * (maxY - minY);
      final y = maxY - barHeight;

      paint.color = data[i].isActive ? activeColor : inactiveColor;

      // Draw bar
      canvas.drawLine(
        Offset(x + barWidth / 2, maxY),
        Offset(x + barWidth / 2, y),
        paint,
      );

      // Draw date label
      final textPainter = TextPainter(
        text: TextSpan(
          text: '${data[i].date.day}',
          style: OnboardingTheme.bodySmall.copyWith(
            color: OnboardingTheme.mediumGray,
          ),
        ),
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x + barWidth / 2 - textPainter.width / 2, maxY + 5),
      );
    }

    // Draw Y-axis labels
    final textPainter = TextPainter(
      textAlign: TextAlign.right,
      textDirection: TextDirection.ltr,
    );

    // Max value
    textPainter.text = TextSpan(
      text: maxStreak.toString(),
      style: OnboardingTheme.bodySmall.copyWith(
        color: OnboardingTheme.mediumGray,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, minY - 8));

    // Min value (0)
    textPainter.text = TextSpan(
      text: '0',
      style: OnboardingTheme.bodySmall.copyWith(
        color: OnboardingTheme.mediumGray,
      ),
    );
    textPainter.layout();
    textPainter.paint(canvas, Offset(0, maxY - 8));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
