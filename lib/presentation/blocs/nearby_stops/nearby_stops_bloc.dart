import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../core/services/location_service.dart';
import 'nearby_stops_event.dart';
import 'nearby_stops_state.dart';

class NearbyStopsBloc extends Bloc<NearbyStopsEvent, NearbyStopsState> {
  final TransitRepository _transitRepository;
  final LocationService _locationService;

  NearbyStopsBloc({
    required TransitRepository transitRepository,
    required LocationService locationService,
  })  : _transitRepository = transitRepository,
        _locationService = locationService,
        super(const NearbyStopsInitial()) {
    // Register event handlers
    on<LoadNearbyStops>(_onLoadNearbyStops);
    on<RefreshNearbyStops>(_onRefreshNearbyStops);
  }

  Future<void> _onLoadNearbyStops(
      LoadNearbyStops event,
      Emitter<NearbyStopsState> emit,
      ) async {
    emit(const NearbyStopsLoading()); // Emit loading state

    try {
      // Get user location
      final position = await _locationService.getCurrentLocation();

      // Get stops from repository
      final stops = await _transitRepository.getNearbyStops(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      emit(NearbyStopsLoaded(
        stops: stops,
        userLat: position.latitude,
        userLng: position.longitude,
      ));
    } catch (e) {
      emit(NearbyStopsError(e.toString()));
    }
  }

  Future<void> _onRefreshNearbyStops(
      RefreshNearbyStops event,
      Emitter<NearbyStopsState> emit,
      ) async {
    // No loading shown on refresh — directly update data
    try {
      final position = await _locationService.getCurrentLocation();
      final stops = await _transitRepository.getNearbyStops(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      emit(NearbyStopsLoaded(
        stops: stops,
        userLat: position.latitude,
        userLng: position.longitude,
      ));
    } catch (e) {
      emit(NearbyStopsError(e.toString()));
    }
  }
}