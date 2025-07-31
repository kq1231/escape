import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeAsync = ref.watch(themeModeNotifierProvider);

    return themeModeAsync.when(
      loading: () =>
          const Scaffold(body: Center(child: CircularProgressIndicator())),
      error: (error, stack) =>
          Scaffold(body: Center(child: Text('Error loading theme: $error'))),
      data: (themeMode) => Scaffold(
        appBar: AppBar(
          title: Text(
            'Settings',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Appearance',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildThemeSelector(context, ref, themeMode),
              const SizedBox(height: 32),
              Text(
                'Other Settings',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildDummySettings(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeSelector(
    BuildContext context,
    WidgetRef ref,
    ThemeMode themeMode,
  ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Theme', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            ListTile(
              title: Text(
                'Light',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(themeModeNotifierProvider.notifier)
                        .saveThemeMode(value);
                  }
                },
              ),
              onTap: () {
                ref
                    .read(themeModeNotifierProvider.notifier)
                    .saveThemeMode(ThemeMode.light);
              },
            ),
            ListTile(
              title: Text(
                'Dark',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(themeModeNotifierProvider.notifier)
                        .saveThemeMode(value);
                  }
                },
              ),
              onTap: () {
                ref
                    .read(themeModeNotifierProvider.notifier)
                    .saveThemeMode(ThemeMode.dark);
              },
            ),
            ListTile(
              title: Text(
                'System Default',
                style: Theme.of(context).textTheme.labelMedium,
              ),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref
                        .read(themeModeNotifierProvider.notifier)
                        .saveThemeMode(value);
                  }
                },
              ),
              onTap: () {
                ref
                    .read(themeModeNotifierProvider.notifier)
                    .saveThemeMode(ThemeMode.system);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummySettings(BuildContext ctx) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              title: Text(
                'Notifications',
                style: Theme.of(ctx).textTheme.labelMedium,
              ),
              value: true,
              onChanged: (value) {},
            ),
            Divider(thickness: 0.1, color: Theme.of(ctx).colorScheme.outline),
            SwitchListTile(
              title: Text('Sound', style: Theme.of(ctx).textTheme.labelMedium),
              value: true,
              onChanged: (value) {},
            ),
            Divider(thickness: 0.1, color: Theme.of(ctx).colorScheme.outline),
            ListTile(
              title: Text(
                'Language',
                style: Theme.of(ctx).textTheme.labelMedium,
              ),
              trailing: Text(
                'English',
                style: Theme.of(ctx).textTheme.labelMedium,
              ),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
