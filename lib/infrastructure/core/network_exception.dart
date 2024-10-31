class RestApiException implements Exception {
  final int? statusCode;
  final dynamic message;

  RestApiException(this.statusCode, [this.message]);
}
