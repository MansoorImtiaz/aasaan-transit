import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class LoadAlerts extends NotificationEvent {
  const LoadAlerts();
}

class MarkAlertAsRead extends NotificationEvent {
  final String alertId;

  const MarkAlertAsRead(this.alertId);

  @override
  List<Object?> get props => [alertId];
}

class SubscribeToLine extends NotificationEvent {
  final String line;

  const SubscribeToLine(this.line);

  @override
  List<Object?> get props => [line];
}

class UnsubscribeFromLine extends NotificationEvent {
  final String line;

  const UnsubscribeFromLine(this.line);

  @override
  List<Object?> get props => [line];
}