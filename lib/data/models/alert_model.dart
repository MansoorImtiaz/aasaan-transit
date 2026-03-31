class AlertModel {
  final String id;
  final String title;
  final String description;
  final String affectedLine;
  final AlertSeverity severity;
  final DateTime timestamp;
  final bool isRead;

  const AlertModel({
    required this.id,
    required this.title,
    required this.description,
    required this.affectedLine,
    required this.severity,
    required this.timestamp,
    this.isRead = false,
  });

  factory AlertModel.fromJson(Map<String, dynamic> json) {
    return AlertModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      affectedLine: json['affectedLine'] ?? '',
      severity: AlertSeverity.values.firstWhere(
            (e) => e.name == json['severity'],
        orElse: () => AlertSeverity.info,
      ),
      timestamp: DateTime.tryParse(json['timestamp'] ?? '') ?? DateTime.now(),
      isRead: json['isRead'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'affectedLine': affectedLine,
      'severity': severity.name,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }

  // Create a copy with updated fields
  AlertModel copyWith({bool? isRead}) {
    return AlertModel(
      id: id,
      title: title,
      description: description,
      affectedLine: affectedLine,
      severity: severity,
      timestamp: timestamp,
      isRead: isRead ?? this.isRead,
    );
  }
}

enum AlertSeverity {
  info,    // normal update
  warning, // minor disruption
  critical // major disruption
}
