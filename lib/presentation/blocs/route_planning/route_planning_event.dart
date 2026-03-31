import 'package:equatable/equatable.dart';

abstract class RoutePlanningEvent extends Equatable {
  const RoutePlanningEvent();

  @override
  List<Object?> get props => [];
}

// User searched for a route
class SearchRoute extends RoutePlanningEvent {
  final double startLat;
  final double startLng;
  final double endLat;
  final double endLng;
  final String startAddress;
  final String endAddress;

  const SearchRoute({
    required this.startLat,
    required this.startLng,
    required this.endLat,
    required this.endLng,
    required this.startAddress,
    required this.endAddress,
  });

  @override
  List<Object?> get props => [
    startLat,
    startLng,
    endLat,
    endLng,
    startAddress,
    endAddress,
  ];
}

// User cleared the route
class ClearRoute extends RoutePlanningEvent {
  const ClearRoute();
}