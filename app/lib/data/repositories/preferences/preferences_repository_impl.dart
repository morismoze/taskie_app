import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../ui/core/utils/intl.dart';
import '../../../utils/command.dart';
import '../../services/local/shared_preferences_service.dart';
import 'preferences_repository.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  PreferencesRepositoryImpl({
    required SharedPreferencesService sharedPreferencesService,
  }) : _sharedPreferencesService = sharedPreferencesService;

  final SharedPreferencesService _sharedPreferencesService;

  final _log = Logger('PreferencesRepository');

  Locale? _appLocale;

  @override
  Locale? get appLocale => _appLocale;

  @override
  Future<Result<Locale?>> loadAppLocale() async {
    if (_appLocale != null) {
      return Result.ok(_appLocale!);
    }

    final result = await _sharedPreferencesService.getAppLanguageCode();

    switch (result) {
      case Ok():
        final appLanguageCode = result.value;
        if (appLanguageCode != null) {
          _appLocale = IntlUtils.getSupportedLanguageFromLangugageCode(
            appLanguageCode,
          ).locale;
          notifyListeners();
        }
        // This is just loading of the locale from storage, we are not gonna set
        // it here if it is missing in storage. That is the job for the AppStartup view model.
        return Result.ok(_appLocale);
      case Error():
        _log.severe(
          'Failed to get app language code from shared prefs',
          result.error,
        );
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<void>> setAppLocale(Locale locale) async {
    if (locale.languageCode == _appLocale?.languageCode) {
      return const Result.ok(null);
    }

    final result = await _sharedPreferencesService.setAppLanguageCode(
      languageCode: locale.languageCode,
    );

    switch (result) {
      case Ok():
        _appLocale = locale;
        notifyListeners();
      case Error():
        _log.severe(
          'Failed to set app language code to shared prefs',
          result.error,
        );
    }

    return result;
  }
}
