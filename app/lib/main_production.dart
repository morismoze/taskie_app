import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';

/// Production config entry point.
/// Launch with `derry run:production`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.root.level = Level.OFF;

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
