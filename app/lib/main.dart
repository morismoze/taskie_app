import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';
import 'data/services/local/database_service.dart';
import 'data/services/local/logger_service.dart';
import 'ui/app_startup/view_models/app_startup_view_model.dart';
import 'ui/app_startup/widgets/app_startup.dart';

/// Development config entry point.
/// Launch with `derry run:development`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await DatabaseService.init();

  LoggerService.init();

  runApp(
    MultiProvider(
      providers: providers,
      child: Builder(
        builder: (context) => AppStartup(
          viewModel: AppStartupViewModel(
            preferencesRepository: context.read(),
            authStateRepository: context.read(),
            clientInfoRepository: context.read(),
          ),
          child: const MainApp(),
        ),
      ),
    ),
  );
}
