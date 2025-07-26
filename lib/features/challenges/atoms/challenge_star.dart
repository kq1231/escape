import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class ChallengeStar extends StatelessWidget {
  final double rating;
  final int maxRating;
  final double size;
  final Color? filledColor;
  final Color? unfilledColor;
  final bool showHalfStars;

  const ChallengeStar({
    super.key,
    this.rating = 0.0,
    this.maxRating = 5,
    this.size = 24.0,
    this.filledColor,
    this.unfilledColor,
    this.showHalfStars = true,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxRating, (index) {
        final starRating = index + 1;
        IconData icon;
        Color color;

        if (rating >= starRating) {
          // Full star
          icon = Icons.star;
          color = filledColor ?? AppTheme.warningOrange;
        } else if (showHalfStars && rating > index) {
          // Half star
          icon = Icons.star_half;
          color = filledColor ?? AppTheme.warningOrange;
        } else {
          // Empty star
          icon = Icons.star_border;
          color = unfilledColor ?? AppTheme.mediumGray;
        }

        return Icon(icon, size: size, color: color);
      }),
    );
  }
}
