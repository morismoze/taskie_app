import 'package:flutter/material.dart';

import '../../../ui/core/utils/intl.dart';
import '../../../utils/command.dart';
import '../../services/local/logger_service.dart';
import '../../services/local/shared_preferences_service.dart';
import 'preferences_repository.dart';

class PreferencesRepositoryImpl extends PreferencesRepository {
  PreferencesRepositoryImpl({
    required SharedPreferencesService sharedPreferencesService,
    required LoggerService loggerService,
  }) : _sharedPreferencesService = sharedPreferencesService,
       _loggerService = loggerService;

  final SharedPreferencesService _sharedPreferencesService;
  final LoggerService _loggerService;

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
          _appLocale = IntlUtils.getSupportedLanguageFromLanguageCode(
            appLanguageCode,
          ).locale;
          notifyListeners();
        }
        // This is just loading of the locale from storage, we are not gonna set
        // it here if it is missing in storage. That is the job for the AppStartup view model.
        return Result.ok(_appLocale);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'sharedPreferencesService.getAppLanguageCode failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        // We don't want to error the program since preferences miss
        // is not fatal as we can always fallback to default values
        return const Result.ok(null);
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
        _loggerService.log(
          LogLevel.error,
          'sharedPreferencesService.setAppLanguageCode failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
    }

    return result;
  }
}
