import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import '../../../../data/repositories/preferences/preferences_repository.dart';
import '../../../../utils/command.dart';
import '../../core/utils/intl.dart';

class LocaleInitializerViewModel {
  LocaleInitializerViewModel({
    required PreferencesRepository preferencesRepository,
  }) : _preferencesRepository = preferencesRepository {
    initializeLocale = Command0(_initializeLocale)..execute();
  }

  final PreferencesRepository _preferencesRepository;

  late Command0 initializeLocale;

  Future<Result<void>> _initializeLocale() async {
    final resultLoadAppLocale = await _preferencesRepository.loadAppLocale();

    // loadAppLocale always returns positive result
    if ((resultLoadAppLocale as Ok<Locale?>).value == null) {
      // Set app locale if locale from shared prefs is null
      final systemLocale = PlatformDispatcher.instance.locale;
      final supportedLocale = IntlUtils.getSupportedLanguageFromLanguageCode(
        systemLocale.languageCode,
      );
      // We don't return error here, because in the case of an error
      // system locale will be used on the MaterialApp.router
      _preferencesRepository.setAppLocale(supportedLocale.locale);
    }

    return const Result.ok(null);
  }
}
