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
  String get errorOnInitialLoad =>
      'Uh-oh! Došlo je do problema prilikom učitavanja vašeg radnog prostora';

  @override
  String get bottomNavigationBarTasksLabel => 'Zadatci';

  @override
  String get bottomNavigationBarLeaderboardLabel => 'Ljestvica';

  @override
  String get bottomNavigationBarGoalsLabel => 'Ciljevi';

  @override
  String get taskCreateNew => 'Stvori novi zadatak';

  @override
  String get goalCreateNew => 'Stvori novi cilj';

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
      'Naziv mora imati najmanje 3 znaka';

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
  String get appDrawerChangeActiveWorkspaceError =>
      'Uh-oh! Došlo je do problema prilikom izmjene aktivnog radnog prostora';

  @override
  String get appDrawerEditWorkspace => 'Uredi postavke radnog prostora';

  @override
  String get appDrawerManageUsers => 'Upravljaj članovima';

  @override
  String get appDrawerLeaveWorkspace => 'Napusti radni prostor';

  @override
  String get appDrawerLeaveWorkspaceModalMessage =>
      'Jeste li sigurni da želite napustiti ovaj radni prostor?';

  @override
  String get appDrawerLeaveWorkspaceModalCta => 'Napusti';

  @override
  String get appDrawerLeaveWorkspaceSuccess =>
      'Uspješno ste napustili radni prostor';

  @override
  String get appDrawerLeaveWorkspaceError =>
      'Uh-oh! Došlo je do problema prilikom brisanja korisnika iz radnog prostora';

  @override
  String get appDrawerCreateNewWorkspace => 'Stvori novi radni prostor';

  @override
  String get appDrawerPreferences => 'Preference';

  @override
  String get createNewTaskNoMembers =>
      'Čini se da vaš radni prostor još nema nijednog člana kojemu se može dodijeliti zadatak. Pokušajte pozvati nekoga ili stvoriti virtualne članove.';

  @override
  String get createNewTaskNoMembersCta => 'Dodajmo članove';

  @override
  String get createNewTaskTitle => 'Novi zadatak';

  @override
  String get taskTitleLabel => 'Naslov zadatka';

  @override
  String get taskDescriptionLabel => 'Opis zadatka';

  @override
  String get taskAssigneeLabel => 'Dodijeli članu';

  @override
  String get taskDueDateLabel => 'Rok završetka';

  @override
  String get taskRewardPointsLabel => 'Nagradni bodovi';

  @override
  String get taskTitleMinLength => 'Naziv mora imati najmanje 3 znaka';

  @override
  String get taskTitleMaxLength => 'Naziv može imati najviše 50 znakova';

  @override
  String get taskDescriptionMaxLength => 'Opis može imati najviše 250 znakova';

  @override
  String get taskAssigneesMinLength =>
      'Zadatak mora biti dodijeljen barem 1 članu';

  @override
  String get submit => 'Potvrdi';

  @override
  String get close => 'Zatvori';

  @override
  String get workspaceUsersManagement => 'Upravljanje korisnicima';

  @override
  String get workspaceUsersManagementCreate => 'Novi korisnik radnog prostora';
}
