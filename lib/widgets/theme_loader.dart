import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../theme/theme_provider.dart';

class ThemeLoader extends ConsumerWidget {
  final Widget child;

  const ThemeLoader({super.key, required this.child});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return _ThemeLoader(ref: ref, child: child);
  }
}

class _ThemeLoader extends ConsumerStatefulWidget {
  final Widget child;
  final WidgetRef ref;

  const _ThemeLoader({required this.child, required this.ref});

  @override
  ConsumerState<_ThemeLoader> createState() => _ThemeLoaderState();
}

class _ThemeLoaderState extends ConsumerState<_ThemeLoader> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final savedTheme = await ThemeService.loadTheme();
    widget.ref.read(themeProvider.notifier).state = savedTheme;
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    return widget.child;
  }
}
