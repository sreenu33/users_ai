import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

import '../errors/exceptions.dart';

/// Interceptor for handling API requests and responses
class ApiInterceptor extends Interceptor {
  final Logger _logger;

  ApiInterceptor({required Logger logger}) : _logger = logger;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.i('➡️ REQUEST: ${options.method} ${options.path}');
    _logger.d('Headers: ${options.headers}');
    _logger.d('Data: ${options.data}');
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    _logger.i(
      '✅ RESPONSE: ${response.statusCode} ${response.requestOptions.path}',
    );
    _logger.d('Data: ${response.data}');
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    _logger.e(
      '❌ ERROR: ${err.response?.statusCode} ${err.requestOptions.path}',
    );
    _logger.e('Error: ${err.message}');
    _logger.e('Response: ${err.response?.data}');

    final exception = _handleDioError(err);
    handler.reject(err.copyWith(error: exception));
  }

  Exception _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return TimeoutException(
          message: 'Connection timeout. Please try again.',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badResponse:
        return _handleHttpError(error);
      case DioExceptionType.connectionError:
        return NetworkException(
          message: 'No internet connection. Please check your connection.',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.badCertificate:
        return ServerException(
          message: 'Bad certificate. Connection not secure.',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.cancel:
        return AppException(
          message: 'Request was cancelled.',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
      case DioExceptionType.unknown:
      default:
        return UnknownException(
          message: error.message ?? 'An unknown error occurred.',
          code: error.response?.statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
    }
  }

  Exception _handleHttpError(DioException error) {
    final statusCode = error.response?.statusCode;
    final message = _getErrorMessage(error.response?.data, statusCode);

    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request.',
          code: statusCode.toString(),
          stackTrace: error.stackTrace,
        );
      case 401:
        return ServerException(
          message: message ?? 'Unauthorized. Please login again.',
          code: statusCode.toString(),
          stackTrace: error.stackTrace,
        );
      case 403:
        return ServerException(
          message: message ?? 'Access forbidden.',
          code: statusCode.toString(),
          stackTrace: error.stackTrace,
        );
      case 404:
        return ServerException(
          message: message ?? 'Resource not found.',
          code: statusCode.toString(),
          stackTrace: error.stackTrace,
        );
      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException(
          message: message ?? 'Server error. Please try again later.',
          code: statusCode.toString(),
          stackTrace: error.stackTrace,
        );
      default:
        return ServerException(
          message: message ?? 'Something went wrong.',
          code: statusCode?.toString(),
          stackTrace: error.stackTrace,
        );
    }
  }

  String? _getErrorMessage(dynamic data, int? statusCode) {
    if (data == null) return null;
    if (data is Map<String, dynamic>) {
      return data['message']?.toString() ??
          data['error']?.toString() ??
          data['errors']?.toString();
    }
    return null;
  }
}
