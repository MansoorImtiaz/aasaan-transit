import 'package:equatable/equatable.dart';
import '../../../data/models/stop_model.dart';

abstract class NearbyStopsState extends Equatable {
  const NearbyStopsState();

  @override
  List<Object?> get props => [];
}

// Initial state
class NearbyStopsInitial extends NearbyStopsState {
  const NearbyStopsInitial();
}

// Loading
class NearbyStopsLoading extends NearbyStopsState {
  const NearbyStopsLoading();
}

// Loaded
class NearbyStopsLoaded extends NearbyStopsState {
  final List<StopModel> stops;
  final double userLat;
  final double userLng;

  const NearbyStopsLoaded({
    required this.stops,
    required this.userLat,
    required this.userLng,
  });

  @override
  List<Object?> get props => [stops, userLat, userLng];
}

// Error
class NearbyStopsError extends NearbyStopsState {
  final String message;

  const NearbyStopsError(this.message);

  @override
  List<Object?> get props => [message];
}