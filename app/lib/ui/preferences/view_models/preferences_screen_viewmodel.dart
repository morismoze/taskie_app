import 'package:flutter/material.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../utils/command.dart';

class PreferencesScreenViewModel extends ChangeNotifier {
  PreferencesScreenViewModel({
    required PreferencesRepository preferencesRepository,
  }) : _preferencesRepository = preferencesRepository {
    _preferencesRepository.addListener(_onPreferencesChanged);
    setAppLocale = Command1(_setAppLocale);
  }

  final PreferencesRepository _preferencesRepository;

  late Command1<void, Locale> setAppLocale;

  /// [appLocale] in [PreferencesRepository] is set up in AppStartup.
  Locale get appLocale => _preferencesRepository.appLocale!;

  void _onPreferencesChanged() {
    notifyListeners();
  }

  Future<Result<void>> _setAppLocale(Locale locale) async {
    final result = await _preferencesRepository.setAppLocale(locale);

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _preferencesRepository.removeListener(_onPreferencesChanged);
    super.dispose();
  }
}
