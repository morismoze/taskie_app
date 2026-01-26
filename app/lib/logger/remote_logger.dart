// infrastructure/logger/api_logger.dart
import '../data/services/api/mobile-logging/mobile_logging_api_service.dart';
import '../data/services/api/mobile-logging/models/request/create_mobile_log_request.dart';
import 'logger_interface.dart';

class RemoteLogger implements LoggerService {
  RemoteLogger({required MobileLoggingApiService apiService})
    : _apiService = apiService;

  final MobileLoggingApiService _apiService;

  String? _userId;

  @override
  void setUser(String userId) => _userId = userId;

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
}
