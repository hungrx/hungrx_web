class ApiException implements Exception {
  final String message;
  ApiException(this.message);
  @override
  String toString() => message;
}

class NetworkException extends ApiException {
  NetworkException(super.message);
}

class ServerException extends ApiException {
  ServerException(super.message);
}

class NotFoundException extends ApiException {
  NotFoundException(super.message);
}
class TimeoutException extends ApiException {
  TimeoutException(super.message);
}