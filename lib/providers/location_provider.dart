import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:escape/services/location_service.dart';
import 'package:escape/providers/prayer_timing_provider.dart';
import 'package:flutter/foundation.dart';

part 'location_provider.g.dart';

/// Provider for managing user location and automatic location detection
@Riverpod(keepAlive: true)
class LocationManager extends _$LocationManager {
  static const String _autoLocationKey = 'auto_location_enabled';
  static const String _lastKnownLocationKey = 'last_known_location';

  @override
  Future<LocationState> build() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if auto location is enabled
    final autoLocationEnabled = prefs.getBool(_autoLocationKey) ?? false;

    // Get last known location if available
    LocationInfo? lastKnownLocation;
    final locationJson = prefs.getString(_lastKnownLocationKey);
    if (locationJson != null) {
      try {
        final Map<String, dynamic> json = Map<String, dynamic>.from(
          Uri.splitQueryString(locationJson),
        );
        // Convert string values back to appropriate types
        json['latitude'] = double.tryParse(json['latitude'] ?? '0') ?? 0.0;
        json['longitude'] = double.tryParse(json['longitude'] ?? '0') ?? 0.0;
        lastKnownLocation = LocationInfo.fromJson(json);
      } catch (e) {
        debugPrint('Error parsing stored location: $e');
      }
    }

    return LocationState(
      autoLocationEnabled: autoLocationEnabled,
      lastKnownLocation: lastKnownLocation,
      isLoading: false,
      error: null,
    );
  }

  /// Enable or disable automatic location detection
  Future<void> setAutoLocationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_autoLocationKey, enabled);

    final currentState = await future;
    state = AsyncValue.data(
      currentState.copyWith(autoLocationEnabled: enabled),
    );

    // If enabling auto location, try to get current location
    if (enabled) {
      await fetchCurrentLocation();
    }
  }

  /// Fetch current location and update prayer settings
  Future<void> fetchCurrentLocation() async {
    final currentState = await future;
    state = AsyncValue.data(
      currentState.copyWith(isLoading: true, error: null),
    );

    try {
      final locationService = LocationService();
      final locationInfo = await locationService.getCurrentLocationInfo();

      if (locationInfo != null) {
        // Store location in preferences
        await _storeLocation(locationInfo);

        // Update prayer settings with new location
        await _updatePrayerSettings(locationInfo);

        state = AsyncValue.data(
          LocationState(
            autoLocationEnabled: currentState.autoLocationEnabled,
            lastKnownLocation: locationInfo,
            isLoading: false,
            error: null,
          ),
        );
      } else {
        state = AsyncValue.data(
          currentState.copyWith(
            isLoading: false,
            error:
                'Unable to get location. Please check permissions and try again.',
          ),
        );
      }
    } catch (e) {
      state = AsyncValue.data(
        currentState.copyWith(
          isLoading: false,
          error: 'Error fetching location: $e',
        ),
      );
    }
  }

  /// Check if location permission is available
  Future<bool> checkLocationPermission() async {
    final locationService = LocationService();
    return await locationService.isLocationAvailable();
  }

  /// Request location permission
  Future<bool> requestLocationPermission() async {
    final locationService = LocationService();
    return await locationService.requestLocationPermission();
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    final locationService = LocationService();
    await locationService.openLocationSettings();
  }

  /// Open app settings
  Future<void> openAppSettings() async {
    final locationService = LocationService();
    await locationService.openAppSettings();
  }

  /// Store location in shared preferences
  Future<void> _storeLocation(LocationInfo location) async {
    final prefs = await SharedPreferences.getInstance();
    final locationData = {
      'city': location.city,
      'country': location.country,
      'latitude': location.latitude.toString(),
      'longitude': location.longitude.toString(),
      'fullAddress': location.fullAddress,
    };

    // Convert to query string format for simple storage
    final locationString = locationData.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');

    await prefs.setString(_lastKnownLocationKey, locationString);
  }

  /// Update prayer settings with location info
  Future<void> _updatePrayerSettings(LocationInfo location) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('country', location.country);
    await prefs.setString('city', location.city);

    // Invalidate prayer timing provider to refresh with new location
    ref.invalidate(prayerTimingProvider);
  }

  /// Clear stored location
  Future<void> clearLocation() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_lastKnownLocationKey);

    final currentState = await future;
    state = AsyncValue.data(currentState.copyWith(lastKnownLocation: null));
  }
}

/// State class for location management
class LocationState {
  final bool autoLocationEnabled;
  final LocationInfo? lastKnownLocation;
  final bool isLoading;
  final String? error;

  const LocationState({
    required this.autoLocationEnabled,
    this.lastKnownLocation,
    required this.isLoading,
    this.error,
  });

  LocationState copyWith({
    bool? autoLocationEnabled,
    LocationInfo? lastKnownLocation,
    bool? isLoading,
    String? error,
  }) {
    return LocationState(
      autoLocationEnabled: autoLocationEnabled ?? this.autoLocationEnabled,
      lastKnownLocation: lastKnownLocation ?? this.lastKnownLocation,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  String toString() {
    return 'LocationState(autoEnabled: $autoLocationEnabled, location: $lastKnownLocation, loading: $isLoading, error: $error)';
  }
}
