class StopModel {
  final String id;
  final String name;
  final double latitude;
  final double longitude;
  final List<String> transitLines;
  final String stopType; // bus, train, metro

  const StopModel({
    required this.id,
    required this.name,
    required this.latitude,
    required this.longitude,
    required this.transitLines,
    required this.stopType,
  });

  factory StopModel.fromJson(Map<String, dynamic> json) {
    return StopModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      transitLines: List<String>.from(json['transitLines'] ?? []),
      stopType: json['stopType'] ?? 'bus',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'latitude': latitude,
      'longitude': longitude,
      'transitLines': transitLines,
      'stopType': stopType,
    };
  }
}