import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/transit_repository.dart';
import '../../../data/models/alert_model.dart';
import 'notification_event.dart';
import 'notification_state.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final TransitRepository _transitRepository;

  NotificationBloc({required TransitRepository transitRepository})
      : _transitRepository = transitRepository,
        super(const NotificationInitial()) {
    on<LoadAlerts>(_onLoadAlerts);
    on<MarkAlertAsRead>(_onMarkAlertAsRead);
    on<SubscribeToLine>(_onSubscribeToLine);
    on<UnsubscribeFromLine>(_onUnsubscribeFromLine);
  }

  Future<void> _onLoadAlerts(
      LoadAlerts event,
      Emitter<NotificationState> emit,
      ) async {
    emit(const NotificationLoading());

    try {
      final alerts = await _transitRepository.getAlerts();
      emit(NotificationLoaded(
        alerts: alerts,
        subscribedLines: [],
      ));
    } catch (e) {
      emit(NotificationError(e.toString()));
    }
  }

  void _onMarkAlertAsRead(
      MarkAlertAsRead event,
      Emitter<NotificationState> emit,
      ) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      final updatedAlerts = currentState.alerts.map((alert) {
        return alert.id == event.alertId
            ? alert.copyWith(isRead: true)
            : alert;
      }).toList();

      emit(NotificationLoaded(
        alerts: updatedAlerts,
        subscribedLines: currentState.subscribedLines,
      ));
    }
  }

  void _onSubscribeToLine(
      SubscribeToLine event,
      Emitter<NotificationState> emit,
      ) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      if (!currentState.subscribedLines.contains(event.line)) {
        emit(NotificationLoaded(
          alerts: currentState.alerts,
          subscribedLines: [...currentState.subscribedLines, event.line],
        ));
      }
    }
  }

  void _onUnsubscribeFromLine(
      UnsubscribeFromLine event,
      Emitter<NotificationState> emit,
      ) {
    if (state is NotificationLoaded) {
      final currentState = state as NotificationLoaded;
      emit(NotificationLoaded(
        alerts: currentState.alerts,
        subscribedLines: currentState.subscribedLines
            .where((line) => line != event.line)
            .toList(),
      ));
    }
  }
}