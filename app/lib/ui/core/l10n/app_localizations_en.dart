// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get signInTitleStart => 'Happy Chores, Happy Kids.';

  @override
  String get signInTitleEnd => 'Happy Home.';

  @override
  String get singInSubtitle =>
      'Organize routines, motivate children, and celebrate every win.';

  @override
  String get signInViaGoogle => 'Sign in via Google';

  @override
  String get signInGoogleCanceled =>
      'Google sign-in cancelled. Please try again.';

  @override
  String get somethingWentWrong => 'Uh-oh! Something went wrong';

  @override
  String get tryAgain => 'Try again';
}
