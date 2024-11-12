class MenuException implements Exception {
  final String message;
  final int? statusCode;

  MenuException(this.message, [this.statusCode]);

  @override
  String toString() => 'MenuException: $message ${statusCode != null ? '(Status: $statusCode)' : ''}';
}