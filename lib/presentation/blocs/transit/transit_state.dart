import 'package:equatable/equatable.dart';

abstract class TransitState extends Equatable {
  const TransitState();

  @override
  List<Object?> get props => [];
}

class TransitInitial extends TransitState {
  const TransitInitial();
}

class TransitLoading extends TransitState {
  const TransitLoading();
}

class TransitLoaded extends TransitState {
  final String stopId;
  final List<Map<String, dynamic>> arrivals;

  const TransitLoaded({
    required this.stopId,
    required this.arrivals,
  });

  @override
  List<Object?> get props => [stopId, arrivals];
}

class TransitError extends TransitState {
  final String message;

  const TransitError(this.message);

  @override
  List<Object?> get props => [message];
}