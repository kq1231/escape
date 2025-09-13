// prayer_timing_provider.dart
import 'dart:convert';
import 'package:escape/models/timings_model.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

part 'prayer_timing_provider.g.dart';

/// A provider that fetches and provides prayer timings.
/// It reads user preferences from Shared Preferences to determine
/// the location and calculation method.
@Riverpod(keepAlive: true)
class PrayerTiming extends _$PrayerTiming {
  @override
  Future<PrayerTimes?> build() async {
    final prefs = await SharedPreferences.getInstance();
    // Get location preferences
    final country = prefs.getString('country');
    final city = prefs.getString('city');

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
          return PrayerTimes.fromJson(data);
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
}
