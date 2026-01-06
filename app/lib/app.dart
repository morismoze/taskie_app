import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/repositories/preferences/preferences_repository.dart';
import 'routing/router.dart';
import 'ui/auth_event_listener/view_models/auth_event_listener_viewmodel.dart';
import 'ui/auth_event_listener/widgets/auth_event_listener.dart';
import 'ui/core/l10n/app_localizations.dart';
import 'ui/core/theme/theme.dart';

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocale = context.watch<PreferencesRepository>().appLocale;

    return MaterialApp.router(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: appLocale,
      theme: AppTheme.lightTheme,
      themeMode: ThemeMode.light,
      debugShowCheckedModeBanner: false,
      routerConfig: router(
        authStateRepository: context.read(),
        workspaceRepository: context.read(),
      ),
      builder: (context, child) => AuthEventListener(
        viewModel: AuthEventListenerViewmodel(
          workspaceRepository: context.read(),
          userRepository: context.read(),
          activeWorkspaceChangeUseCase: context.read(),
        ),
        child: child!,
      ),
    );
  }
}
