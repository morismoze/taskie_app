import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'config/dependencies.dart';
import 'main.dart';

/// Production config entry point.
/// Launch with `flutter run --target lib/main_production.dart`.
void main() {
  Logger.root.level = Level.OFF;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
