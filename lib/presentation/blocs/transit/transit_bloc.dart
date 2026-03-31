import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transit_repository.dart';
import 'transit_event.dart';
import 'transit_state.dart';

class TransitBloc extends Bloc<TransitEvent, TransitState> {
  final TransitRepository _transitRepository;

  TransitBloc({required TransitRepository transitRepository})
      : _transitRepository = transitRepository,
        super(const TransitInitial()) {
    on<LoadTransitSchedule>(_onLoadTransitSchedule);
    on<RefreshTransitSchedule>(_onRefreshTransitSchedule);
  }

  Future<void> _onLoadTransitSchedule(
      LoadTransitSchedule event,
      Emitter<TransitState> emit,
      ) async {
    emit(const TransitLoading());

    try {
      final schedule = await _transitRepository.getTransitSchedule(
        stopId: event.stopId,
      );

      emit(TransitLoaded(
        stopId: event.stopId,
        arrivals: List<Map<String, dynamic>>.from(schedule['arrivals']),
      ));
    } catch (e) {
      emit(TransitError(e.toString()));
    }
  }

  Future<void> _onRefreshTransitSchedule(
      RefreshTransitSchedule event,
      Emitter<TransitState> emit,
      ) async {
    try {
      final schedule = await _transitRepository.getTransitSchedule(
        stopId: event.stopId,
      );

      emit(TransitLoaded(
        stopId: event.stopId,
        arrivals: List<Map<String, dynamic>>.from(schedule['arrivals']),
      ));
    } catch (e) {
      emit(TransitError(e.toString()));
    }
  }
}