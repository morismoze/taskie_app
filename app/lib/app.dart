import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:provider/provider.dart';

import 'core/l10n/app_localizations.dart';
import 'routing/router.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      themeMode: ThemeMode.system,
      routerConfig: router(context.read()),
      debugShowCheckedModeBanner: false,
      builder: (context, child) => FTheme(
        data: FThemes.blue.light,
        child: FToaster(child: child!),
      ),
    );
  }
}
