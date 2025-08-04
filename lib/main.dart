import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_startup_provider.dart';
import 'widgets/app_startup_state_widgets.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(ProviderScope(child: AppStartupWidget()));
}

class AppStartupWidget extends ConsumerWidget {
  const AppStartupWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final appStartupState = ref.watch(appStartupProvider);

    return appStartupState.when(
      // Loading state
      loading: () => const AppStartupLoadingWidget(),

      // Error state
      error: (error, stackTrace) => AppStartupErrorWidget(
        message: error.toString(),
        onRetry: () => ref.read(appStartupProvider.notifier).retry(),
      ),

      // Success state
      data: (_) => const AppStartupSuccessWidget(),
    );
  }
}
