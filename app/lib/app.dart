import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:toastification/toastification.dart';

import 'data/repositories/preferences/preferences_repository.dart';
import 'ui/app_startup/widgets/app_startup.dart';
import 'ui/auth_event_listener/widgets/auth_event_listener.dart';
import 'ui/core/l10n/app_localizations.dart';
import 'ui/core/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocale = context.watch<PreferencesRepository>().appLocale;
    final goRouter = context.read<GoRouter>();

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appLocale,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: goRouter,
      builder: (context, child) => ToastificationConfigProvider(
        config: const ToastificationConfig(alignment: Alignment.topCenter),
        child: AppStartup(
          viewModel: context.read(),
          child: AuthEventListener(viewModel: context.read(), child: child!),
        ),
      ),
    );
  }
}
