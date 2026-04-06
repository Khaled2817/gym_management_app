import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';

class LocationHelper {
  // Check if location service is enabled
  static Future<bool> isLocationServiceEnabled() async {
    return await Geolocator.isLocationServiceEnabled();
  }

  // Check and request location permission
  static Future<LocationPermissionResult> checkPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationPermissionResult.denied;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return LocationPermissionResult.deniedForever;
    }

    return LocationPermissionResult.granted;
  }

  // Get current position
  static Future<Position?> getCurrentPosition() async {
    try {
      final serviceEnabled = await isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      final permissionResult = await checkPermission();
      if (permissionResult != LocationPermissionResult.granted) {
        return null;
      }

      return await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 30),
          distanceFilter: 100,
        ),
      );
    } catch (e) {
      debugPrint('Error getting location: $e');
      return null;
    }
  }

  // Check if location is mock (fake GPS)
  static Future<bool> isMockLocation(Position position) async {
    return position.isMocked;
  }

  // Check if VPN is likely connected (basic check)
  static Future<bool> isVPNConnected() async {
    try {
      // This is a basic check - you might need a more sophisticated method
      // Check if the position accuracy is suspiciously low
      final position = await getCurrentPosition();
      if (position != null) {
        // VPN often causes location inconsistencies
        // You can add more checks here
        return false;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  // Validate location for attendance
  static Future<LocationValidationResult> validateLocation() async {
    // Check if location service is enabled
    final serviceEnabled = await isLocationServiceEnabled();
    if (!serviceEnabled) {
      return LocationValidationResult(
        isValid: false,
        error: 'خدمة الموقع غير مفعلة، يرجى تفعيلها',
        position: null,
      );
    }

    // Check permission
    final permissionResult = await checkPermission();
    if (permissionResult == LocationPermissionResult.denied) {
      return LocationValidationResult(
        isValid: false,
        error: 'تم رفض إذن الموقع',
        position: null,
      );
    }

    if (permissionResult == LocationPermissionResult.deniedForever) {
      return LocationValidationResult(
        isValid: false,
        error: 'إذن الموقع مرفوض للأبد، يرجى تفعيله من الإعدادات',
        position: null,
      );
    }

    // Get current position
    final position = await getCurrentPosition();
    if (position == null) {
      return LocationValidationResult(
        isValid: false,
        error: 'فشل في الحصول على الموقع',
        position: null,
      );
    }

    // Check for mock location
    if (await isMockLocation(position)) {
      return LocationValidationResult(
        isValid: false,
        error: 'تم اكتشاف موقع وهمي (Mock Location)، يرجى إيقافه',
        position: position,
      );
    }

    return LocationValidationResult(
      isValid: true,
      error: null,
      position: position,
    );
  }
}

enum LocationPermissionResult {
  granted,
  denied,
  deniedForever,
}

class LocationValidationResult {
  final bool isValid;
  final String? error;
  final Position? position;

  LocationValidationResult({
    required this.isValid,
    this.error,
    this.position,
  });
}
