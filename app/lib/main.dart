import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:logging/logging.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';

/// Development config entry point.
/// Launch with `derry run:development`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  Logger.root.level = Level.ALL;
  Logger.root.onRecord.listen((record) {
    print(
      '[${record.loggerName}] - ${record.level.name} - ${record.time} - ${record.message} - ${record.stackTrace}',
    );
  });

  runApp(MultiProvider(providers: providers, child: const MainApp()));
}
