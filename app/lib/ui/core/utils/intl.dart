import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

typedef SupportedLanguage = ({Locale locale, String name});

abstract final class IntlUtils {
  static SupportedLanguage defaultSupportedLanguage = (
    locale: const Locale('en', 'US'),
    name: 'English (US)',
  );

  static List<SupportedLanguage> supportedLanguages = [
    defaultSupportedLanguage,
    const (locale: Locale('hr', 'HR'), name: 'Hrvatski (HR)'),
  ];

  static SupportedLanguage getSupportedLanguageFromLanguageCode(
    String languageCode,
  ) {
    return supportedLanguages.firstWhere(
      (lang) => lang.locale.languageCode == languageCode,
      orElse: () => defaultSupportedLanguage,
    );
  }

  static String getDisplayName(Locale locale) {
    final exactMatch = supportedLanguages.firstWhereOrNull(
      (e) =>
          e.locale.languageCode == locale.languageCode &&
          e.locale.countryCode == locale.countryCode,
    );

    if (exactMatch != null) {
      return exactMatch.name;
    }

    // Fallback - check only by language code
    final languageOnlyMatch = supportedLanguages.firstWhere(
      (e) => e.locale.languageCode == locale.languageCode,
      orElse: () => (locale: locale, name: locale.toString()),
    );

    return languageOnlyMatch.name;
  }

  static String mapDateTimeToLocalTimeZoneFormat(
    BuildContext context,
    DateTime dateTime,
  ) => DateFormat.yMd(
    Localizations.localeOf(context).toString(),
  ).format(dateTime.toLocal());
}
