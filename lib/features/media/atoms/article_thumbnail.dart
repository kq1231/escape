import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

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
        color: AppTheme.lightGray,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        image: imageUrl != null
            ? DecorationImage(image: NetworkImage(imageUrl!), fit: fit)
            : null,
      ),
      child: imageUrl == null
          ? Icon(Icons.image_outlined, color: AppTheme.mediumGray, size: 40)
          : null,
    );

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: thumbnail);
    }

    return thumbnail;
  }
}
