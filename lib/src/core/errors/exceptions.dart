/// Base class for all exceptions
class AppException implements Exception {
  final String message;
  final String? code;
  final StackTrace? stackTrace;

  const AppException({required this.message, this.code, this.stackTrace});

  @override
  String toString() => 'AppException(message: $message, code: $code)';
}

/// Server exception for API errors
class ServerException extends AppException {
  const ServerException({required super.message, super.code, super.stackTrace});
}

/// Network exception for connectivity issues
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Cache exception for local storage errors
class CacheException extends AppException {
  const CacheException({required super.message, super.code, super.stackTrace});
}

/// Timeout exception for request timeouts
class TimeoutException extends AppException {
  const TimeoutException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}

/// Unknown exception for unexpected errors
class UnknownException extends AppException {
  const UnknownException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
