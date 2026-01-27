import 'logger_interface.dart';

/// This is a logger delegate class. It's used to set
/// RemoteLogger instead of default ConsoleLogger as
/// LoggerService. It's needed due to circular dependency
/// problem with RemoteLogger implementation.
class LoggerHub implements LoggerService {
  LoggerHub(this._delegate);

  LoggerService _delegate;
  bool _delegateSet = false;

  @override
  void setUser(String userId) {
    _delegate.setUser(userId);
  }

  @override
  void clearState() {
    _delegate.clearState();
  }

  @override
  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
    String? context,
  }) {
    _delegate.log(
      level,
      message,
      error: error,
      stackTrace: stackTrace,
      context: context,
    );
  }

  void setDelegate(LoggerService loggerService) {
    // Guard for accidental multiple setup
    if (_delegateSet) {
      return;
    }
    _delegateSet = true;
    _delegate = loggerService;
  }
}
