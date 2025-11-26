import 'dart:ui';
import 'package:escape/features/onboarding/atoms/liquid_border_button.dart';
import 'package:flutter/material.dart';

class LiquidBorderButton extends StatelessWidget {

  const LiquidBorderButton({
    required this.animation, required this.onTap, required this.child, super.key,
  });
  final Animation<double> animation;
  final VoidCallback onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: CustomPaint(
        painter: LiquidBorderPainter(animation: animation),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.18),
                    Colors.white.withOpacity(0.05),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.white.withOpacity(0.3),
                  width: 1.2,
                ),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
