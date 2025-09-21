import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:flutter/foundation.dart';

/// Service for handling location-related operations
class LocationService {
  static final LocationService _instance = LocationService._internal();
  factory LocationService() => _instance;
  LocationService._internal();

  /// Check if location services are enabled and permissions are granted
  Future<bool> isLocationAvailable() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check location permission
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error checking location availability: $e');
      return false;
    }
  }

  /// Request location permission from user
  Future<bool> requestLocationPermission() async {
    try {
      // First check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // Location services are not enabled, ask user to enable them
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        // Permissions are denied forever, we cannot request permissions
        return false;
      }

      return true;
    } catch (e) {
      debugPrint('Error requesting location permission: $e');
      return false;
    }
  }

  /// Get current location coordinates
  Future<Position?> getCurrentLocation() async {
    try {
      bool hasPermission = await isLocationAvailable();
      if (!hasPermission) {
        hasPermission = await requestLocationPermission();
        if (!hasPermission) {
          return null;
        }
      }

      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
        ),
      );

      return position;
    } catch (e) {
      debugPrint('Error getting current location: $e');
      return null;
    }
  }

  /// Get city and country from coordinates using reverse geocoding
  Future<LocationInfo?> getLocationInfo(
    double latitude,
    double longitude,
  ) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks.first;

        String? city =
            place.locality ??
            place.subAdministrativeArea ??
            place.administrativeArea;
        String? country = place.country;

        if (city != null && country != null) {
          return LocationInfo(
            city: city,
            country: country,
            latitude: latitude,
            longitude: longitude,
            fullAddress: _formatAddress(place),
          );
        }
      }

      return null;
    } catch (e) {
      debugPrint('Error getting location info: $e');
      return null;
    }
  }

  /// Get current location info (coordinates + city/country)
  Future<LocationInfo?> getCurrentLocationInfo() async {
    try {
      Position? position = await getCurrentLocation();
      if (position == null) return null;

      return await getLocationInfo(position.latitude, position.longitude);
    } catch (e) {
      debugPrint('Error getting current location info: $e');
      return null;
    }
  }

  /// Format address from placemark
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.administrativeArea != null &&
        place.administrativeArea!.isNotEmpty) {
      addressParts.add(place.administrativeArea!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return addressParts.join(', ');
  }

  /// Open location settings
  Future<void> openLocationSettings() async {
    try {
      await Geolocator.openLocationSettings();
    } catch (e) {
      debugPrint('Error opening location settings: $e');
    }
  }

  /// Check if location permission is granted
  Future<bool> checkLocationPermission() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      return permission == LocationPermission.always ||
          permission == LocationPermission.whileInUse;
    } catch (e) {
      debugPrint('Error checking location permission: $e');
      return false;
    }
  }

  /// Open app settings for permission management
  Future<bool> openAppSettings() async {
    try {
      return await Geolocator.openAppSettings();
    } catch (e) {
      debugPrint('Error opening app settings: $e');
      return false;
    }
  }
}

/// Model class for location information
class LocationInfo {
  final String city;
  final String country;
  final double latitude;
  final double longitude;
  final String fullAddress;

  LocationInfo({
    required this.city,
    required this.country,
    required this.latitude,
    required this.longitude,
    required this.fullAddress,
  });

  @override
  String toString() {
    return 'LocationInfo(city: $city, country: $country, lat: $latitude, lng: $longitude)';
  }

  /// Convert to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'city': city,
      'country': country,
      'latitude': latitude,
      'longitude': longitude,
      'fullAddress': fullAddress,
    };
  }

  /// Create from JSON
  factory LocationInfo.fromJson(Map<String, dynamic> json) {
    return LocationInfo(
      city: json['city'] ?? '',
      country: json['country'] ?? '',
      latitude: json['latitude']?.toDouble() ?? 0.0,
      longitude: json['longitude']?.toDouble() ?? 0.0,
      fullAddress: json['fullAddress'] ?? '',
    );
  }
}
