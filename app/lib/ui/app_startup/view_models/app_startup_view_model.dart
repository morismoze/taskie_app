import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../data/repositories/auth/auth_state_repository.dart';
import '../../../data/repositories/client_info/client_info_repository_impl.dart';
import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../utils/command.dart';
import '../../core/utils/intl.dart';

class AppStartupViewModel {
  AppStartupViewModel({
    required PreferencesRepository preferencesRepository,
    required AuthStateRepository authStateRepository,
    required ClientInfoRepository clientInfoRepository,
  }) : _preferencesRepository = preferencesRepository,
       _authStateRepository = authStateRepository,
       _clientInfoRepository = clientInfoRepository {
    bootstrap = Command0(_bootstrap)..execute();
  }

  final PreferencesRepository _preferencesRepository;
  final AuthStateRepository _authStateRepository;
  final ClientInfoRepository _clientInfoRepository;

  late Command0 bootstrap;

  Future<Result<void>> _bootstrap() async {
    // 1.a Load app locale from shared prefs
    final resultLoadAppLocale = await _preferencesRepository.loadAppLocale();

    // loadAppLocale always returns positive result
    if ((resultLoadAppLocale as Ok<Locale?>).value == null) {
      // 1.b Set app locale if locale from shared prefs is null
      final systemLocale = PlatformDispatcher.instance.locale;
      final supportedLocale = IntlUtils.getSupportedLanguageFromLanguageCode(
        systemLocale.languageCode,
      );
      final result = await _preferencesRepository.setAppLocale(
        supportedLocale.locale,
      );

      switch (result) {
        case Ok():
          break;
        case Error():
          return Result.error(result.error);
      }
    }

    // No need to check the result. This will either set the [isAuthenticated]
    // state to `true` or it will remain to `false`. That state will then be
    // inspected by the gorouter redirect function when gorouter builds the routes
    // initially.
    await _authStateRepository.loadAuthenticatedState();

    // Init client info
    await _clientInfoRepository.initializeClientInfo();

    return const Result.ok(null);
  }
}
