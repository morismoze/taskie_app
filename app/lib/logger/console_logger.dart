// infrastructure/logger/console_logger.dart
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'logger_interface.dart';

/// Used for development
class ConsoleLogger implements LoggerService {
  ConsoleLogger() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      var logOutput =
          '[${record.loggerName}] | ${record.level.name} | ${record.time} | ${record.message}';

      if (record.error != null) {
        logOutput += ' | Error: ${record.error}';
      }

      if (record.stackTrace != null) {
        logOutput += '\nSTACK TRACE:\n${record.stackTrace}';
      }

      debugPrint(logOutput);
    });
  }

  final Logger _logger = Logger('ConsoleLogger');

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
    final userPrefix = _userId != null ? '[User: $_userId] ' : '';
    final contextSuffix = context != null ? ' | $context' : '';
    final msg = '$userPrefix$message$contextSuffix';

    switch (level) {
      case LogLevel.debug:
        _logger.fine(msg, error, stackTrace);
        break;
      case LogLevel.info:
        _logger.info(msg, error, stackTrace);
        break;
      case LogLevel.warn:
        _logger.warning(msg, error, stackTrace);
        break;
      case LogLevel.error:
        _logger.severe(msg, error, stackTrace);
        break;
      case LogLevel.fatal:
        _logger.shout(msg, error, stackTrace);
        break;
    }
  }
}
