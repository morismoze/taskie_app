import 'package:flutter/material.dart';

import '../../../utils/command.dart';

abstract class PreferencesRepository extends ChangeNotifier {
  Locale? get appLocale;

  Future<Result<Locale?>> loadAppLocale();

  Future<Result<void>> setAppLocale(Locale locale);
}
