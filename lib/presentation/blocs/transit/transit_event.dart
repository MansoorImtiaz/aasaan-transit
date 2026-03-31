import 'package:equatable/equatable.dart';

abstract class TransitEvent extends Equatable {
  const TransitEvent();

  @override
  List<Object?> get props => [];
}

class LoadTransitSchedule extends TransitEvent {
  final String stopId;

  const LoadTransitSchedule(this.stopId);

  @override
  List<Object?> get props => [stopId];
}

class RefreshTransitSchedule extends TransitEvent {
  final String stopId;

  const RefreshTransitSchedule(this.stopId);

  @override
  List<Object?> get props => [stopId];
}