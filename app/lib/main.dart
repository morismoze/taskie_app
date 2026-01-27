import 'package:device_preview/device_preview.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app.dart';
import 'config/dependencies.dart';
import 'data/services/local/database_service.dart';
import 'ui/localization_listener/view_models/locale_initializer_view_model.dart';
import 'ui/localization_listener/widgets/locale_initializer.dart';

/// Development entry point
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await DatabaseService.init();

  await Firebase.initializeApp();

  const enableDevicePreview = false;
  runApp(
    MultiProvider(
      providers: buildProviders(enableRemoteLogging: false),
      child: Builder(
        builder: (context) => LocaleInitializer(
          viewModel: LocaleInitializerViewModel(
            preferencesRepository: context.read(),
          ),
          child: DevicePreview(
            enabled: enableDevicePreview,
            devices: [
              ...Devices.all,
              DeviceInfo.genericPhone(
                platform: TargetPlatform.android,
                id: 'zfold_cover',
                name: 'Z Fold (Cover)',
                screenSize: const Size(904 / 3, 2316 / 3),
                pixelRatio: 3.0,
              ),
              DeviceInfo.genericTablet(
                platform: TargetPlatform.android,
                id: 'zfold_main',
                name: 'Z Fold (Main)',
                screenSize: const Size(1812 / 3, 2176 / 3),
                pixelRatio: 3.0,
              ),
            ],
            builder: (_) =>
                const MainApp(enableDevicePreview: enableDevicePreview),
          ),
        ),
      ),
    ),
  );
}
