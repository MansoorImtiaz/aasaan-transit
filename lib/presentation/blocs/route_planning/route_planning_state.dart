import 'package:equatable/equatable.dart';
import '../../../data/models/route_model.dart';

abstract class RoutePlanningState extends Equatable {
  const RoutePlanningState();

  @override
  List<Object?> get props => [];
}

class RoutePlanningInitial extends RoutePlanningState {
  const RoutePlanningInitial();
}

class RoutePlanningLoading extends RoutePlanningState {
  const RoutePlanningLoading();
}

class RoutePlanningLoaded extends RoutePlanningState {
  final RouteModel route;

  const RoutePlanningLoaded(this.route);

  @override
  List<Object?> get props => [route];
}

class RoutePlanningError extends RoutePlanningState {
  final String message;

  const RoutePlanningError(this.message);

  @override
  List<Object?> get props => [message];
}