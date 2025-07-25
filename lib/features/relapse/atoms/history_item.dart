import 'package:flutter/material.dart';
import '../../onboarding/constants/onboarding_theme.dart';

class HistoryItem extends StatelessWidget {
  final String title;
  final String date;
  final String? description;
  final IconData? icon;
  final Color? iconColor;
  final VoidCallback? onTap;

  const HistoryItem({
    super.key,
    required this.title,
    required this.date,
    this.description,
    this.icon,
    this.iconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(OnboardingTheme.radiusM),
        child: Padding(
          padding: EdgeInsets.all(OnboardingTheme.spacingM),
          child: Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: EdgeInsets.all(OnboardingTheme.spacingS),
                  decoration: BoxDecoration(
                    color:
                        iconColor?.withValues(alpha: 0.1) ??
                        OnboardingTheme.errorRed.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    color: iconColor ?? OnboardingTheme.errorRed,
                    size: 24,
                  ),
                ),
                SizedBox(width: OnboardingTheme.spacingM),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: OnboardingTheme.headlineSmall),
                    SizedBox(height: OnboardingTheme.spacingXS),
                    Text(
                      date,
                      style: OnboardingTheme.bodySmall.copyWith(
                        color: OnboardingTheme.mediumGray,
                      ),
                    ),
                    if (description != null) ...[
                      SizedBox(height: OnboardingTheme.spacingS),
                      Text(
                        description!,
                        style: OnboardingTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
