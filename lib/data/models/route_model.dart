class RouteModel {
  final String id;
  final String startAddress;
  final String endAddress;
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final List<RouteStep> steps;
  final double distanceKm;
  final int durationMinutes;
  final List<List<double>> polylinePoints; // for drawing route on map

  const RouteModel({
    required this.id,
    required this.startAddress,
    required this.endAddress,
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.steps,
    required this.distanceKm,
    required this.durationMinutes,
    required this.polylinePoints,
  });

  factory RouteModel.fromJson(Map<String, dynamic> json) {
    // ORS API response parsing
    final summary = json['summary'] ?? {};
    final segmentSteps =
        (json['segments'] as List?)?.first['steps'] as List? ?? [];

    return RouteModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      startAddress: json['startAddress'] ?? '',
      endAddress: json['endAddress'] ?? '',
      startLat: (json['startLat'] ?? 0.0).toDouble(),
      startLng: (json['startLng'] ?? 0.0).toDouble(),
      endLat: (json['endLat'] ?? 0.0).toDouble(),
      endLng: (json['endLng'] ?? 0.0).toDouble(),
      distanceKm: ((summary['distance'] ?? 0) / 1000).toDouble(),
      durationMinutes: ((summary['duration'] ?? 0) / 60).round(),
      steps: segmentSteps
          .map((s) => RouteStep.fromJson(s))
          .toList(),
      polylinePoints: (json['geometry']?['coordinates'] as List?)
          ?.map((c) => [
        (c[1] as num).toDouble(),
        (c[0] as num).toDouble(),
      ])
          .toList() ??
          [],
    );
  }
}

class RouteStep {
  final String instruction;
  final double distanceMeters;
  final int durationSeconds;

  const RouteStep({
    required this.instruction,
    required this.distanceMeters,
    required this.durationSeconds,
  });

  factory RouteStep.fromJson(Map<String, dynamic> json) {
    return RouteStep(
      instruction: json['instruction'] ?? '',
      distanceMeters: (json['distance'] ?? 0.0).toDouble(),
      durationSeconds: (json['duration'] ?? 0).toInt(),
    );
  }
}