import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

class DeviceMetaService {
  final Dio _externalDio;
  DeviceMetaService(this._externalDio);

  static const String _vapidKey = 'BJCLns56lRwDtnoXeEJwZnramONKchPWtb6Us4VtKA-qRiD43YvHd9j-ZTKiGtJyAsgeWWSY7OULtkzg6PpVRAY';

  Future<Map<String, dynamic>> fetchLoginMetaData() async {
    Sentry.addBreadcrumb(
      Breadcrumb(
        message: 'Initiating device metadata extraction (GPS + Network) for login audit',
        category: 'device.meta',
        level: SentryLevel.info,
      ),
    );
    final (fcmToken, latLong) = await (_getFcmToken(), _getLatLong()).wait;
    final timeData = _getLoginTimestamp();
    return {
      'firebase_token': fcmToken,
      'latitude': latLong?['latitude'] ?? 'Unknown Latitude',
      'longitude': latLong?['longitude'] ?? 'Unknown Longitude',
      'login_date': timeData['login_date'] ?? 'Unknown Login Date',
      'login_time': timeData['login_time'] ?? 'Unknown Login Time',
    };
  }

  Future<Map<String, String>?> _getLatLong() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) return null;

      LocationPermission locPermission = await Geolocator.checkPermission();
      if (locPermission == LocationPermission.denied) {
        locPermission = await Geolocator.requestPermission();
        if (locPermission == LocationPermission.denied) return null; // Permission denied by user
      }

      if (locPermission == LocationPermission.deniedForever) return null; // Permanently denied
      const LocationSettings locationSettings = LocationSettings(accuracy: LocationAccuracy.high);

      Position position = await Geolocator.getCurrentPosition(locationSettings: locationSettings);

      return {'latitude': position.latitude.toString(), 'longitude': position.longitude.toString()};
    } catch (e, stackTrace) {
      await Sentry.captureException(
        Exception('GPS Extraction/Geocoding Failed: $e'),
        stackTrace: stackTrace,
        withScope: (scope) => scope.setTag('layer', 'gps_service'),
      );
      debugPrint("--- [DEVICE META] GPS Failed: $e ---");
      return null;
    }
  }

  Future<String> _getFcmToken() async {
    try {
      NotificationSettings notificationSettings = await FirebaseMessaging.instance.requestPermission(
        provisional: true,
        alert: true,
        badge: true,
        sound: true,
      );

      if (notificationSettings.authorizationStatus != AuthorizationStatus.authorized) {
        Sentry.addBreadcrumb(
          Breadcrumb(
            message: 'User explicitly denied FCM notification permission on Web',
            category: 'device.meta.fcm',
            level: SentryLevel.warning,
          ),
        );
        debugPrint("--- [DEVICE META] User denied notification permission on Web ---");
        return 'web_permission_denied';
      }
      final token = await FirebaseMessaging.instance.getToken(vapidKey: _vapidKey);
      return token ?? 'web_token_unavailable';
    } catch (e, stackTrace) {
      await Sentry.captureException(
        Exception('FCM Token Generation Failed (Web Shield/Permission Denied): $e'),
        stackTrace: stackTrace,
        withScope: (scope) {
          scope.setTag('layer', 'device_meta_service');
          scope.setTag('platform', kIsWeb ? 'web' : 'native');
        },
      );
      debugPrint("--- [DEVICE META] FCM Token extraction blocked or failed: $e ---");
      return kIsWeb ? 'web_permission_denied_or_blocked' : 'native_token_error';
    }
  }

  Map<String, String> _getLoginTimestamp() {
    final now = DateTime.now().toUtc();
    return {
      'login_date': now.toIso8601String(), // Format: YYYY-MM-DD
      'login_time': now.toIso8601String().split('T').last.split('.').first, // Format: HH:MM:SS
    };
  }
}
