// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get signInTitleStart => 'Učenje odgovornosti.';

  @override
  String get signInTitleEnd => 'Zabava nagrađivanja.';

  @override
  String get singInSubtitle =>
      'Organizirajte rutine, motivirajte djecu i slavite svaku pobjedu.';

  @override
  String get signInViaGoogle => 'Prijavi se putem Googlea';

  @override
  String get signInGoogleCanceled =>
      'Google prijava otkazana. Molimo pokušajte ponovno.';

  @override
  String get somethingWentWrong => 'Uh-oh! Nešto je pošlo po zlu';

  @override
  String get tryAgain => 'Pokušajte ponovno';

  @override
  String get errorWhileLoadingWorkspaces =>
      'Uh-oh! Došlo je do problema prilikom učitavanja vaših radnih prostora';
}
