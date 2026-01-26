import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';
import 'data/services/local/database_service.dart';
import 'ui/localization_listener/view_models/locale_initializer_view_model.dart';
import 'ui/localization_listener/widgets/locale_initializer.dart';

/// Production config entry point.
/// Launch with `derry run:production`
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await DatabaseService.init();

  runApp(
    MultiProvider(
      providers: buildProviders(enableRemoteLogging: true),
      child: Builder(
        builder: (context) => LocaleInitializer(
          viewModel: LocaleInitializerViewModel(
            preferencesRepository: context.read(),
          ),
          child: const MainApp(),
        ),
      ),
    ),
  );
}
