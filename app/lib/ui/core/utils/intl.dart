import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

abstract final class IntlUtils {
  static SupportedLanguage defaultSupportedLanguage = const SupportedLanguage(
    Locale('en', 'US'),
    'English (US)',
  );

  static List<SupportedLanguage> supportedLanguages = [
    defaultSupportedLanguage,
    const SupportedLanguage(Locale('hr', 'HR'), 'Hrvatski (HR)'),
  ];

  static SupportedLanguage getSupportedLanguageFromLangugageCode(
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
      orElse: () => SupportedLanguage(locale, locale.toString()),
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

class SupportedLanguage {
  final Locale locale;
  final String name;

  const SupportedLanguage(this.locale, this.name);
}
