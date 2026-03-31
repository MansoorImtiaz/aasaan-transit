import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/route_repository.dart';
import 'route_planning_event.dart';
import 'route_planning_state.dart';

class RoutePlanningBloc extends Bloc<RoutePlanningEvent, RoutePlanningState> {
  final RouteRepository _routeRepository;

  RoutePlanningBloc({required RouteRepository routeRepository})
      : _routeRepository = routeRepository,
        super(const RoutePlanningInitial()) {
    on<SearchRoute>(_onSearchRoute);
    on<ClearRoute>(_onClearRoute);
  }

  Future<void> _onSearchRoute(
      SearchRoute event,
      Emitter<RoutePlanningState> emit,
      ) async {
    emit(const RoutePlanningLoading());

    try {
      final route = await _routeRepository.getRoute(
        startLat: event.startLat,
        startLng: event.startLng,
        endLat: event.endLat,
        endLng: event.endLng,
        startAddress: event.startAddress,
        endAddress: event.endAddress,
      );

      emit(RoutePlanningLoaded(route));
    } catch (e) {
      emit(RoutePlanningError(e.toString()));
    }
  }

  void _onClearRoute(
      ClearRoute event,
      Emitter<RoutePlanningState> emit,
      ) {
    emit(const RoutePlanningInitial());
  }
}