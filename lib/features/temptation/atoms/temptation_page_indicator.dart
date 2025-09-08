import 'package:flutter/material.dart';
import 'package:escape/theme/app_constants.dart';

class TemptationPageIndicator extends StatelessWidget {
  final int currentPage;
  final int pageCount;
  final Color? activeColor;
  final Color? inactiveColor;

  const TemptationPageIndicator({
    super.key,
    required this.currentPage,
    required this.pageCount,
    this.activeColor,
    this.inactiveColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(pageCount, (index) {
        final isActive = index == currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          height: 8,
          width: isActive ? 24 : 8,
          decoration: BoxDecoration(
            color: isActive
                ? (activeColor ?? AppConstants.primaryGreen)
                : (inactiveColor ?? AppConstants.mediumGray),
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}
