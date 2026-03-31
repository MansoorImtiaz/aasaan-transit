import 'package:flutter/material.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/nearby_stops/nearby_stops_screen.dart';
import '../presentation/screens/route_planning/route_planning_screen.dart';
import '../presentation/screens/transit/transit_screen.dart';
import '../presentation/screens/alerts/alerts_screen.dart';

class AppRoutes {
  static const String home = '/';
  static const String nearbyStops = '/nearby-stops';
  static const String routePlanning = '/route-planning';
  static const String transit = '/transit';
  static const String alerts = '/alerts';

  static Map<String, WidgetBuilder> get routes => {
    home: (_) => const HomeScreen(),
    nearbyStops: (_) => const NearbyStopsScreen(),
    routePlanning: (_) => const RoutePlanningScreen(),
    transit: (_) => const TransitScreen(),
    alerts: (_) => const AlertsScreen(),
  };
}