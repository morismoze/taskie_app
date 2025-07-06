// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get cancel => 'Otkaži';

  @override
  String get signInTitleStart => 'Učenje odgovornosti.';

  @override
  String get signInTitleEnd => 'Zabava nagrađivanja.';

  @override
  String get signInSubtitle =>
      'Organizirajte rutine, motivirajte djecu i slavite svaki uspjeh.';

  @override
  String get signInGetStarted => 'Započnimo';

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

  @override
  String get tasksLabel => 'Zadatci';

  @override
  String get leaderboardLabel => 'Ljestvica';

  @override
  String get goalsLabel => 'Ciljevi';

  @override
  String get workspaceNameLabel => 'Naziv radnog prostora';

  @override
  String get workspaceDescriptionLabel => 'Opis radnog prostora';

  @override
  String get workspaceCreateTitle => 'Stvorimo novi radni prostor';

  @override
  String workspaceCreateSubtitle(Object email) {
    return 'Nismo pronašli postojeće radne prostore za $email. Ako je to greška, pokušajte zamoliti vlasnika radnog prostora za pozivni link.';
  }

  @override
  String get workspaceCreateLabel => 'Stvori radni prostor';

  @override
  String get workspaceCreateNameMinLength =>
      'Naziv mora imati minimalno 3 znakova';

  @override
  String get workspaceCreateNameMaxLength =>
      'Naziv može imati najviše 50 znakova';

  @override
  String get workspaceCreateDescriptionMaxLength =>
      'Opis može imati najviše 250 znakova';

  @override
  String get requiredField => 'Ovo polje je obvezno';

  @override
  String get optional => 'opcionalno';

  @override
  String get errorWhileCreatingWorkspace =>
      'Uh-oh! Došlo je do problema prilikom kreiranja radnog prostora';

  @override
  String get tasksHello => 'Pozdrav!';

  @override
  String get appDrawerTitle => 'Radni prostori';

  @override
  String get appDrawerEditWorkspace => 'Uredi postavke radnog prostora';

  @override
  String get appDrawerInviteMembers => 'Pozovi nove članove';

  @override
  String get appDrawerLeaveWorkspace => 'Napusti radni prostor';

  @override
  String get appDrawerLeaveWorkspaceModalMessage =>
      'Jeste li sigurni da želite napustiti ovaj radni prostor?';

  @override
  String get appDrawerLeaveWorkspaceModalCta => 'Napusti';

  @override
  String appDrawerLeaveWorkspaceSuccess(Object workspaceName) {
    return 'Uspješno ste napustili $workspaceName radni prostor';
  }

  @override
  String get appDrawerLeaveWorkspaceError =>
      'Uh-oh! Došlo je do problema prilikom brisanja korisnika iz radnog prostora';

  @override
  String get appDrawerCreateNewWorkspace => 'Stvori novi radni prostor';

  @override
  String get appDrawerPreferences => 'Preference';
}
