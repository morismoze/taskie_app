enum LogLevel { debug, info, warn, error, fatal }

abstract class LoggerService {
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? context,
  });
  void setUser(String userId);
  void clearState();
}
