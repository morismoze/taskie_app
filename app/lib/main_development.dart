import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';

/// Development config entry point.
/// Launch with `derry run:development`
void main() {
  Logger.root.level = Level.ALL;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
