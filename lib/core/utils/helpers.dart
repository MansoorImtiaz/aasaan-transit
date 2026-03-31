class AppHelpers {
  // Convert meters to readable format
  static String formatDistance(double meters) {
    if (meters < 1000) {
      return '${meters.toStringAsFixed(0)} m';
    }
    return '${(meters / 1000).toStringAsFixed(1)} km';
  }

  // Convert seconds to readable format
  static String formatDuration(int seconds) {
    if (seconds < 60) {
      return '$seconds sec';
    }
    final minutes = seconds ~/ 60;
    if (minutes < 60) {
      return '$minutes min';
    }
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}min';
  }

  // Get stop type icon
  static String getStopTypeIcon(String stopType) {
    switch (stopType) {
      case 'metro':
        return '🚇';
      case 'train':
        return '🚆';
      case 'bus':
      default:
        return '🚌';
    }
  }

  // Get alert severity color hex
  static int getAlertColor(String severity) {
    switch (severity) {
      case 'critical':
        return 0xFFE53935;
      case 'warning':
        return 0xFFFFA726;
      case 'info':
      default:
        return 0xFF1E88E5;
    }
  }

  // Format arrival time
  static String formatArrival(int minutes) {
    if (minutes <= 0) return 'Arriving now';
    if (minutes == 1) return 'In 1 minute';
    return 'In $minutes minutes';
  }
}