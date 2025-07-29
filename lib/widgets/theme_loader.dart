import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeLoader extends ConsumerWidget {
  final Widget child;

  const ThemeLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // With the new theme provider, we don't need to load the theme separately
    // The theme is loaded through the provider, so we can just return the child
    return child;
  }
}
