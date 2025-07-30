import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../utils/command.dart';
import '../../core/utils/intl.dart';

class AppStartupViewModel {
  AppStartupViewModel({required PreferencesRepository preferencesRepository})
    : _preferencesRepository = preferencesRepository {
    bootstrap = Command0(_bootstrap)..execute();
  }

  final PreferencesRepository _preferencesRepository;
  final _log = Logger('AppStartupViewModel');

  late Command0 bootstrap;

  Future<Result<void>> _bootstrap() async {
    // 1.a Load app locale from shared prefs
    final resultLoadAppLocale = await _preferencesRepository.loadAppLocale();

    switch (resultLoadAppLocale) {
      case Ok<Locale?>():
        break;
      case Error<Locale?>():
        _log.severe('Failed to get app locale', resultLoadAppLocale.error);
        return Result.error(resultLoadAppLocale.error);
    }

    if (resultLoadAppLocale.value == null) {
      // 1.b Set app locale if locale from shared prefs is null
      final systemLocale = PlatformDispatcher.instance.locale;
      final supportedLocale = IntlUtils.getSupportedLanguageFromLangugageCode(
        systemLocale.languageCode,
      );
      final result = await _preferencesRepository.setAppLocale(
        supportedLocale.locale,
      );

      switch (result) {
        case Ok():
          break;
        case Error():
          _log.severe('Failed to set app locale', result.error);
          return Result.error(result.error);
      }
    }

    return const Result.ok(null);
  }
}
