import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConstants {
  // App Info
  static const String appName = 'AasaanTransit';

  // ORS API
  static const String orsBaseUrl = 'https://api.openrouteservice.org';
  static String get orsApiKey => dotenv.env['ORS_API_KEY'] ?? '';

  // Map defaults — Islamabad center
  static const double defaultLat = 33.6844;
  static const double defaultLng = 73.0479;
  static const double defaultZoom = 14.0;

  // Transit mock data refresh interval (seconds)
  static const int refreshInterval = 30;
}