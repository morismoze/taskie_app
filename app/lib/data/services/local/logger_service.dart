import 'dart:convert';

import 'package:logging/logging.dart';

enum LogLevel { debug, info, warn, error, fatal }

class LoggerService {
  final Logger _logger = Logger('LoggerService');

  String? _userId;

  void setUser(String? userId) => _userId = userId;

  // This is used on user sign out
  void clearState() {
    _userId = null;
  }

  void log(
    LogLevel level,
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    final extras = <String, Object?>{if (_userId != null) 'userId': _userId};
    final formattedMessage = extras.isEmpty
        ? message
        : '$message | ctx=${_safeJson(extras)}';

    switch (level) {
      case LogLevel.debug:
        _logger.fine(formattedMessage, error, stackTrace);
        break;
      case LogLevel.info:
        _logger.info(formattedMessage, error, stackTrace);
        break;
      case LogLevel.warn:
        _logger.warning(formattedMessage, error, stackTrace);
        break;
      case LogLevel.error:
        _logger.severe(formattedMessage, error, stackTrace);
        break;
      case LogLevel.fatal:
        _logger.shout(formattedMessage, error, stackTrace);
        break;
    }
  }

  static void init({bool off = false}) {
    if (off) {
      Logger.root.level = Level.OFF;
      return;
    }

    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      print(
        '[${record.loggerName}] - ${record.level.name} - ${record.time} - ${record.message} - ${record.stackTrace}',
      );
    });
  }

  String _safeJson(Map<String, Object?> map) {
    try {
      return jsonEncode(map);
    } catch (_) {
      return map.toString();
    }
  }
}
