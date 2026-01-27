import 'package:dio/dio.dart';

import '../config/api_endpoints.dart';
import '../data/services/api/exceptions/general_api_exception.dart';
import '../data/services/api/mobile-logging/mobile_logging_api_service.dart';
import '../data/services/api/mobile-logging/models/request/create_mobile_log_request.dart';
import 'logger_interface.dart';

class RemoteLogger implements LoggerService {
  RemoteLogger({required MobileLoggingApiService apiService})
    : _apiService = apiService;

  final MobileLoggingApiService _apiService;

  String? _userId;

  @override
  void setUser(String userId) {
    if (_userId == userId) {
      return;
    }
    _userId = userId;
  }

  // This is used on user sign out
  @override
  void clearState() {
    _userId = null;
  }

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? context,
  }) {
    // User ID is decoded from the access token on the API if the user
    // is authenticated.
    // Device metadata (OS, model, app version, build number, etc) is
    // sent on all requests via the ApiClient interceptor.

    // Filter debug and info level, as we won't send those
    if (level == LogLevel.debug || level == LogLevel.info) {
      return;
    }

    // Smart filter of what errors should be remote logged
    if (error != null && !_shouldLogError(error)) {
      return;
    }

    final payload = CreateMobileLogRequest(
      userId: _userId,
      level: level,
      message: message,
      stackTrace: stackTrace?.toString(),
      context: context,
    );

    // Fire & Forget
    _apiService.createMobileLog(payload);
  }

  bool _shouldLogError(Object error) {
    // API already logs pretty much everything
    if (error is GeneralApiException) {
      return false;
    }

    if (error is! DioException) {
      return true;
    }

    // Stop recursion - if mobile log request fails.
    // This is already solved in the MobileLoggingApiService by
    // returning Ok result in case of exceptions.
    final path = error.requestOptions.path;
    if (path.contains(ApiEndpoints.createMobileLog) ||
        path.endsWith(ApiEndpoints.createMobileLog)) {
      return false;
    }

    // Don't log cancel errors
    if (error.type == DioExceptionType.cancel) {
      return false;
    }

    // If we got a response, backend/proxy returned something.
    // API maps all backend errors into GeneralApiException with specific error code,
    // then any DioException with response is "unexpected" (e.g. HTML 502, non-json, mapper missed it).
    if (error.response != null) {
      final status = error.response?.statusCode;
      final ct = error.response?.headers.value(Headers.contentTypeHeader) ?? '';
      final isJson = ct.contains('application/json');

      // HTML/text error
      if (!isJson) {
        return true;
      }

      // Otherwise (proxy HTML, gateway, etc) -> log (especially 5xx)
      return status == null || status >= 500;
    }

    // Timeout/connection/unknown
    return true;
  }
}
