import 'package:escape/providers/prayer_timing_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../theme/app_constants.dart';
import '../../../theme/theme_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  late final TextEditingController _countryController;
  late final TextEditingController _cityController;

  @override
  void initState() {
    super.initState();
    _countryController = TextEditingController();
    _cityController = TextEditingController();
    _loadPrayerTimeSettings();
  }

  @override
  void dispose() {
    _countryController.dispose();
    _cityController.dispose();
    super.dispose();
  }

  Future<void> _loadPrayerTimeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _countryController.text = prefs.getString('country') ?? '';
    _cityController.text = prefs.getString('city') ?? '';
  }

  Future<void> _savePrayerTimeSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', _countryController.text);
    await prefs.setString('city', _cityController.text);
    // You can add a success message or trigger a refresh here if needed
  }

  @override
  Widget build(BuildContext context) {
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
                'Prayer Time',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildPrayerTimeSettings(context),
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
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
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

  Widget _buildPrayerTimeSettings(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Location', style: Theme.of(context).textTheme.labelLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _countryController,
              decoration: InputDecoration(
                labelText: 'Country',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                ),
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _savePrayerTimeSettings().then((_) {
                  // After saving, refresh the prayer timing provider
                  ref.invalidate(prayerTimingProvider);
                  // You can add a SnackBar to confirm the save
                  if (!context.mounted) return;
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Prayer time settings saved!'),
                      duration: Duration(seconds: 2),
                    ),
                  );
                });
              },
              child: const Text('Save Settings'),
            ),
          ],
        ),
      ),
    );
  }
}
