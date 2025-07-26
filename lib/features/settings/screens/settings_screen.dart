import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/theme_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Settings', style: AppTheme.headlineMedium),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Appearance', style: AppTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildThemeSelector(context, ref, themeMode),
            const SizedBox(height: 32),
            Text('Other Settings', style: AppTheme.headlineSmall),
            const SizedBox(height: 16),
            _buildDummySettings(),
          ],
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
            Text('Theme', style: AppTheme.bodyLarge),
            const SizedBox(height: 16),
            ListTile(
              title: Text('Light', style: AppTheme.bodyMedium),
              leading: Radio<ThemeMode>(
                value: ThemeMode.light,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).state = value;
                    ThemeService.saveTheme(value);
                  }
                },
              ),
              onTap: () {
                ref.read(themeProvider.notifier).state = ThemeMode.light;
                ThemeService.saveTheme(ThemeMode.light);
              },
            ),
            ListTile(
              title: Text('Dark', style: AppTheme.bodyMedium),
              leading: Radio<ThemeMode>(
                value: ThemeMode.dark,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).state = value;
                    ThemeService.saveTheme(value);
                  }
                },
              ),
              onTap: () {
                ref.read(themeProvider.notifier).state = ThemeMode.dark;
                ThemeService.saveTheme(ThemeMode.dark);
              },
            ),
            ListTile(
              title: Text('System Default', style: AppTheme.bodyMedium),
              leading: Radio<ThemeMode>(
                value: ThemeMode.system,
                groupValue: themeMode,
                onChanged: (value) {
                  if (value != null) {
                    ref.read(themeProvider.notifier).state = value;
                    ThemeService.saveTheme(value);
                  }
                },
              ),
              onTap: () {
                ref.read(themeProvider.notifier).state = ThemeMode.system;
                ThemeService.saveTheme(ThemeMode.system);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDummySettings() {
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
              title: Text('Notifications', style: AppTheme.bodyMedium),
              value: true,
              onChanged: (value) {},
            ),
            const Divider(),
            SwitchListTile(
              title: Text('Sound', style: AppTheme.bodyMedium),
              value: true,
              onChanged: (value) {},
            ),
            const Divider(),
            ListTile(
              title: Text('Language', style: AppTheme.bodyMedium),
              trailing: Text('English', style: AppTheme.bodyMedium),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }
}
