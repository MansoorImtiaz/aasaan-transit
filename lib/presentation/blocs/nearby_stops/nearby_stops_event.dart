import 'package:equatable/equatable.dart';

abstract class NearbyStopsEvent extends Equatable {
  const NearbyStopsEvent();

  @override
  List<Object?> get props => [];
}

// User searched for a route
class LoadNearbyStops extends NearbyStopsEvent {
  const LoadNearbyStops();
}

// User cleared the route
class RefreshNearbyStops extends NearbyStopsEvent {
  const RefreshNearbyStops();
}