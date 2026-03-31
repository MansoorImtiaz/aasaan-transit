abstract class Failure {
  final String message;
  const Failure(this.message);
}

class LocationFailure extends Failure {
  const LocationFailure(super.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure(super.message);
}

class ApiFailure extends Failure {
  const ApiFailure(super.message);
}