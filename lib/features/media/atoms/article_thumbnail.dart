import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class ArticleThumbnail extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final VoidCallback? onTap;

  const ArticleThumbnail({
    super.key,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final thumbnail = Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: OnboardingTheme.lightGray,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: fit)
            : null,
      ),
      child: imageUrl == null
          ? Icon(
              Icons.image_outlined,
              color: OnboardingTheme.mediumGray,
              size: 40,
            )
          : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: thumbnail);
    }

    return thumbnail;
  }
}
