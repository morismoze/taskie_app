import 'package:flutter/material.dart';

import 'app_localizations.dart';

extension AppLocalizationsExtension on BuildContext {
  AppLocalizations get localization => AppLocalizations.of(this)!;
}
