import '../models/stop_model.dart';
import '../models/alert_model.dart';

class TransitRepository {
  // Mock nearby stops data
  Future<List<StopModel>> getNearbyStops({
    required double latitude,
    required double longitude,
  }) async {
    // Simulating API delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      StopModel(
        id: 's1',
        name: 'City Center Bus Stop',
        latitude: latitude + 0.002,
        longitude: longitude + 0.003,
        transitLines: ['Route 1', 'Route 5', 'Route 12'],
        stopType: 'bus',
      ),
      StopModel(
        id: 's2',
        name: 'Metro Station',
        latitude: latitude - 0.001,
        longitude: longitude + 0.002,
        transitLines: ['Metro Line A', 'Metro Line B'],
        stopType: 'metro',
      ),
      StopModel(
        id: 's3',
        name: 'Railway Station',
        latitude: latitude + 0.004,
        longitude: longitude - 0.001,
        transitLines: ['Express Train', 'Local Train'],
        stopType: 'train',
      ),
      StopModel(
        id: 's4',
        name: 'Airport Bus Terminal',
        latitude: latitude - 0.003,
        longitude: longitude - 0.002,
        transitLines: ['Route 8', 'Airport Express'],
        stopType: 'bus',
      ),
      StopModel(
        id: 's5',
        name: 'University Stop',
        latitude: latitude + 0.001,
        longitude: longitude - 0.004,
        transitLines: ['Route 3', 'Route 7'],
        stopType: 'bus',
      ),
    ];
  }

  // Mock transit schedules
  Future<Map<String, dynamic>> getTransitSchedule({
    required String stopId,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return {
      'stopId': stopId,
      'arrivals': [
        {
          'line': 'Route 1',
          'arrivalMinutes': 3,
          'status': 'on_time',
        },
        {
          'line': 'Route 5',
          'arrivalMinutes': 7,
          'status': 'delayed',
          'delayMinutes': 2,
        },
        {
          'line': 'Route 12',
          'arrivalMinutes': 15,
          'status': 'on_time',
        },
      ],
    };
  }

  // Mock alerts
  Future<List<AlertModel>> getAlerts() async {
    await Future.delayed(const Duration(seconds: 1));

    return [
      AlertModel(
        id: 'a1',
        title: 'Route 5 Delay',
        description: 'Route 5 is experiencing delays due to road work near City Center.',
        affectedLine: 'Route 5',
        severity: AlertSeverity.warning,
        timestamp: DateTime.now().subtract(const Duration(minutes: 15)),
      ),
      AlertModel(
        id: 'a2',
        title: 'Metro Line A Suspended',
        description: 'Metro Line A is temporarily suspended between Station 3 and Station 7.',
        affectedLine: 'Metro Line A',
        severity: AlertSeverity.critical,
        timestamp: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      AlertModel(
        id: 'a3',
        title: 'New Route 15 Added',
        description: 'A new bus route has been added connecting Downtown to Airport.',
        affectedLine: 'Route 15',
        severity: AlertSeverity.info,
        timestamp: DateTime.now().subtract(const Duration(hours: 3)),
      ),
    ];
  }
}