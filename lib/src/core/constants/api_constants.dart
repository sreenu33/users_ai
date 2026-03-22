/// API Constants for the application
class ApiConstants {
  ApiConstants._();

  /// Base URL for JSONPlaceholder API
  static const String baseUrl = 'https://jsonplaceholder.typicode.com';

  /// Endpoints
  static const String users = '/users';

  /// Timeouts
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;
  static const int sendTimeout = 30000;
}
