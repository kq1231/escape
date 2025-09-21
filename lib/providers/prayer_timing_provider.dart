// prayer_timing_provider.dart
import 'dart:convert';
import 'package:escape/models/timings_model.dart';
import 'package:escape/services/notification_service.dart';
import 'package:escape/services/location_service.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart';

part 'prayer_timing_provider.g.dart';

/// A provider that fetches and provides prayer timings.
/// It reads user preferences from Shared Preferences to determine
/// the location and calculation method.
@Riverpod(keepAlive: true)
class PrayerTiming extends _$PrayerTiming {
  @override
  Future<PrayerTimes?> build() async {
    final prefs = await SharedPreferences.getInstance();

    // Check if auto location is enabled
    final autoLocationEnabled = prefs.getBool('auto_location_enabled') ?? false;

    String? country;
    String? city;

    if (autoLocationEnabled) {
      // Try to get location automatically
      final locationService = LocationService();
      final locationInfo = await locationService.getCurrentLocationInfo();

      if (locationInfo != null) {
        country = locationInfo.country;
        city = locationInfo.city;

        // Store the fetched location for future use
        await prefs.setString('country', country);
        await prefs.setString('city', city);
      } else {
        // Fall back to stored location if auto location fails
        country = prefs.getString('country');
        city = prefs.getString('city');
      }
    } else {
      // Use manually set location
      country = prefs.getString('country');
      city = prefs.getString('city');
    }

    // Return null if country or city is empty
    if (country == null || country.isEmpty || city == null || city.isEmpty) {
      return null;
    }

    final school = prefs.getString('school') ?? 'Hanfi';

    // Get current date in DD-MM-YYYY format
    final now = DateTime.now();
    final formattedDate = DateFormat('dd-MM-yyyy').format(now);

    // Map the school preference to the API's calculation method.
    final uri = Uri.https(
      'api.aladhan.com',
      '/v1/timingsByCity/$formattedDate',
      {
        'city': city,
        'country': country,
        'method': '1', // University of Islamic Sciences, Karachi
        'school': school == "Hanfi" ? '1' : '0',
      },
    );

    try {
      final response = await http.get(uri);
      if (response.statusCode == 200) {
        final Map<String, dynamic> json = jsonDecode(response.body);
        if (json['status'] == 'OK') {
          // Ensure the data is properly structured
          final data = json['data'] as Map<String, dynamic>;
          final prayerTimes = PrayerTimes.fromJson(data);

          // Schedule prayer notifications
          await _schedulePrayerNotifications(prayerTimes);

          return prayerTimes;
        } else {
          throw Exception(
            'API returned an error: ${json['data']['status'] ?? 'Unknown'}',
          );
        }
      } else {
        throw Exception(
          'Failed to load prayer times: HTTP status code ${response.statusCode}',
        );
      }
    } catch (e) {
      // Catch any other exceptions (e.g., network errors)
      throw Exception('An error occurred while fetching prayer times: $e');
    }
  }

  /// Schedule prayer notifications for today's timings
  Future<void> _schedulePrayerNotifications(PrayerTimes prayerTimes) async {
    try {
      final notificationService = NotificationService();
      await notificationService.schedulePrayerNotifications(
        prayerTimes.timings,
      );
    } catch (e) {
      // Don't throw error for notification scheduling failure
      // Just log it and continue
      debugPrint('Failed to schedule prayer notifications: $e');
    }
  }

  /// Refresh prayer times with current location
  Future<void> refreshWithCurrentLocation() async {
    final prefs = await SharedPreferences.getInstance();
    final locationService = LocationService();

    try {
      final locationInfo = await locationService.getCurrentLocationInfo();

      if (locationInfo != null) {
        // Update stored location
        await prefs.setString('country', locationInfo.country);
        await prefs.setString('city', locationInfo.city);

        // Invalidate current state to trigger rebuild
        ref.invalidateSelf();
      }
    } catch (e) {
      debugPrint('Failed to refresh with current location: $e');
    }
  }

  /// Enable/disable automatic location detection
  Future<void> setAutoLocationEnabled(bool enabled) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('auto_location_enabled', enabled);

    // Invalidate current state to trigger rebuild
    ref.invalidateSelf();
  }
}
