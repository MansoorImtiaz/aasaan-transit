import 'package:equatable/equatable.dart';
import '../../../data/models/alert_model.dart';

abstract class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {
  const NotificationInitial();
}

class NotificationLoading extends NotificationState {
  const NotificationLoading();
}

class NotificationLoaded extends NotificationState {
  final List<AlertModel> alerts;
  final List<String> subscribedLines;

  const NotificationLoaded({
    required this.alerts,
    required this.subscribedLines,
  });

  @override
  List<Object?> get props => [alerts, subscribedLines];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError(this.message);

  @override
  List<Object?> get props => [message];
}