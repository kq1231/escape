import 'dart:async';
import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class CountdownTimer extends StatefulWidget {
  final int minutes;
  final VoidCallback? onComplete;
  final Color? primaryColor;
  final Color? backgroundColor;

  const CountdownTimer({
    super.key,
    required this.minutes,
    this.onComplete,
    this.primaryColor,
    this.backgroundColor,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> {
  late int _totalSeconds;
  late int _remainingSeconds;
  Timer? _timer;

  // Helper method to get appropriate text color for dark mode
  Color _getTextColor(Color defaultColor) {
    final brightness = MediaQuery.platformBrightnessOf(context);
    return brightness == Brightness.dark ? Colors.white : defaultColor;
  }

  @override
  void initState() {
    super.initState();
    _totalSeconds = widget.minutes * 60;
    _remainingSeconds = _totalSeconds;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() {
          _remainingSeconds--;
        });
      } else {
        _timer?.cancel();
        widget.onComplete?.call();
      }
    });
  }

  String _formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final remainingSeconds = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$remainingSeconds';
  }

  double _getProgress() {
    return (_totalSeconds - _remainingSeconds) / _totalSeconds;
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = widget.primaryColor ?? AppTheme.primaryGreen;
    final backgroundColor = widget.backgroundColor ?? AppTheme.lightGreen;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Circular progress indicator
        Stack(
          alignment: Alignment.center,
          children: [
            // Background circle
            Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                color: backgroundColor.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
            ),
            // Progress circle
            SizedBox(
              width: 200,
              height: 200,
              child: CircularProgressIndicator(
                value: _getProgress(),
                strokeWidth: 8,
                backgroundColor: backgroundColor.withValues(alpha: 0.3),
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
            // Time text
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(_remainingSeconds),
                  style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: primaryColor,
                    fontSize: 48,
                  ),
                ),
                Text(
                  'remaining',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: _getTextColor(AppTheme.mediumGray),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: AppTheme.spacingXL),
        // Instruction text
        Text(
          'Focus on your chosen activity and resist the temptation',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: _getTextColor(AppTheme.darkGreen),
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppTheme.spacingM),
        // Breathing animation hint
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.air, color: AppTheme.primaryGreen, size: 20),
            const SizedBox(width: 8),
            Text(
              'Take deep breaths when feeling overwhelmed',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _getTextColor(AppTheme.mediumGray),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
