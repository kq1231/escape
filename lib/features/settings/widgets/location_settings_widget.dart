import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:escape/providers/location_provider.dart';
import 'package:escape/theme/app_constants.dart';

/// Widget for managing location settings in the settings screen
class LocationSettingsWidget extends ConsumerWidget {
  const LocationSettingsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationState = ref.watch(locationManagerProvider);

    return locationState.when(
      loading: () => const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(child: CircularProgressIndicator()),
        ),
      ),
      error: (error, stack) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Error: $error',
                style: const TextStyle(color: AppConstants.errorRed),
              ),
            ],
          ),
        ),
      ),
      data: (state) => Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Location Settings',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              // Auto Location Toggle
              SwitchListTile(
                title: const Text('Automatic Location'),
                subtitle: const Text(
                  'Automatically detect your location for prayer times',
                ),
                value: state.autoLocationEnabled,
                onChanged: (value) async {
                  if (value) {
                    // Check permission before enabling
                    final hasPermission = await ref
                        .read(locationManagerProvider.notifier)
                        .checkLocationPermission();

                    if (!hasPermission) {
                      final granted = await ref
                          .read(locationManagerProvider.notifier)
                          .requestLocationPermission();

                      if (!granted) {
                        _showPermissionDialog(context, ref);
                        return;
                      }
                    }
                  }

                  await ref
                      .read(locationManagerProvider.notifier)
                      .setAutoLocationEnabled(value);
                },
                activeColor: AppConstants.primaryGreen,
              ),

              const Divider(),

              // Current Location Info
              if (state.lastKnownLocation != null) ...[
                const Text(
                  'Current Location:',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppConstants.primaryGreen.withOpacity(0.3),
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(
                            Icons.location_city,
                            size: 16,
                            color: AppConstants.primaryGreen,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${state.lastKnownLocation!.city}, ${state.lastKnownLocation!.country}',
                            style: const TextStyle(fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        state.lastKnownLocation!.fullAddress,
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
              ],

              // Action Buttons
              Row(
                children: [
                  if (state.autoLocationEnabled) ...[
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: state.isLoading
                            ? null
                            : () async {
                                await ref
                                    .read(locationManagerProvider.notifier)
                                    .fetchCurrentLocation();
                              },
                        icon: state.isLoading
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.my_location),
                        label: Text(
                          state.isLoading ? 'Updating...' : 'Update Location',
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppConstants.primaryGreen,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ] else ...[
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          final granted = await ref
                              .read(locationManagerProvider.notifier)
                              .requestLocationPermission();

                          if (granted) {
                            await ref
                                .read(locationManagerProvider.notifier)
                                .setAutoLocationEnabled(true);
                          } else {
                            _showPermissionDialog(context, ref);
                          }
                        },
                        icon: const Icon(Icons.location_on),
                        label: const Text('Enable Location'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppConstants.primaryGreen,
                          side: const BorderSide(
                            color: AppConstants.primaryGreen,
                          ),
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Error Display
              if (state.error != null) ...[
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppConstants.errorRed.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: AppConstants.errorRed.withOpacity(0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.error_outline,
                        color: AppConstants.errorRed,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          state.error!,
                          style: const TextStyle(
                            color: AppConstants.errorRed,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  void _showPermissionDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Location Permission Required'),
        content: const Text(
          'To automatically detect your location for accurate prayer times, please grant location permission in your device settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await ref
                  .read(locationManagerProvider.notifier)
                  .openAppSettings();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppConstants.primaryGreen,
              foregroundColor: Colors.white,
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }
}
