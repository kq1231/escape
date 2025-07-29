import 'package:flutter/material.dart';
import 'package:escape/theme/app_theme.dart';

class MediaFeed extends StatelessWidget {
  final List<Widget> items;
  final String? title;
  final VoidCallback? onRefresh;
  final bool isLoading;

  const MediaFeed({
    super.key,
    required this.items,
    this.title,
    this.onRefresh,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        if (title != null) ...[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppTheme.spacingM),
            child: Text(
              title!,
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          SizedBox(height: AppTheme.spacingM),
        ],
        // Content
        if (isLoading) ...[
          const Center(
            child: Padding(
              padding: EdgeInsets.all(AppTheme.spacingL),
              child: CircularProgressIndicator(),
            ),
          ),
        ] else ...[
          // Refresh indicator
          RefreshIndicator(
            onRefresh: () async {
              if (onRefresh != null) {
                onRefresh!();
              }
            },
            child: ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(
                    left: AppTheme.spacingM,
                    right: AppTheme.spacingM,
                    bottom: AppTheme.spacingM,
                  ),
                  child: items[index],
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}
