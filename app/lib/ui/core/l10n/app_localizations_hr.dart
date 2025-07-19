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
  String get appDrawerEditWorkspace => 'Postavke radnog prostora';

  @override
  String get appDrawerManageUsers => 'Članovi radnog prostora';

  @override
  String get appDrawerNotActiveWorkspace =>
      'Ukoliko želite vidjeti ostale opcije, učinite ovaj radni prostor aktivnim klikom na ikonu radnog prostora u gornjoj listi.';

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
  String get workspaceUsersManagementDeleteUser =>
      'Ukloni korisnika iz radnog prostora';

  @override
  String get workspaceUsersManagementDeleteUserModalMessage =>
      'Jeste li sigurni da želite ukloniti ovog korisnika iz radnog prostora?';

  @override
  String get workspaceUsersManagementDeleteUserModalCta => 'Ukloni';

  @override
  String get workspaceUsersManagementDeleteUserSuccess =>
      'Uspješno ste uklonili korisnika iz radnog prostora';

  @override
  String get workspaceUsersManagementDeleteUserError =>
      'Uh-oh! Došlo je do problema prilikom uklanjanja korisnika iz radnog prostora';

  @override
  String get workspaceUsersManagementUsersGuideMainTitle =>
      'O korisnicima radnog prostora';

  @override
  String get workspaceUsersManagementUsersGuideIntroBody =>
      'Svi sudionici u radnom prostoru dijele se na dva glavna tipa: Članove tima (koji imaju vlastiti korisnički račun) i Virtualne profile (koji su placeholderi kojima upravljaju Menadžeri). Svakom korisniku je zatim dodijeljena uloga koja definira njegove dozvole.';

  @override
  String get workspaceUsersManagementUsersGuideTeamMembersTitle =>
      'Članovi tima (Stvarni korisnici)';

  @override
  String get workspaceUsersManagementUsersGuideTeamMembersBody =>
      'Članovi tima su korisnici s vlastitim računom koji se mogu prijaviti u aplikaciju. Oni ili stvore radni prostor (čime automatski postaju Menadžeri) ili se pridruže postojećem putem pozivne poveznice (čime automatski postaju Članovi). Uloge Članova tima može mijenjati Menadžer.';

  @override
  String get workspaceUsersManagementUsersGuideVirtualProfilesTitle =>
      'Virtualni profili';

  @override
  String get workspaceUsersManagementUsersGuideVirtualProfilesBody =>
      'Virtualni profili su placeholderi za osobe koje nemaju korisnički račun, poput djece. Oni se ne mogu prijaviti. Stvaraju ih isključivo Menadžeri i uvijek im se dodjeljuje uloga \'Član\', koja se ne može promijeniti.';

  @override
  String get workspaceUsersManagementUsersGuideRolesTitle =>
      'Korisničke uloge: Menadžer i Član';

  @override
  String get workspaceUsersManagementUsersGuideRolesBody =>
      'Svakom korisniku u radnom prostoru dodijeljena je jedna od dvije uloge. Korisnik koji stvori radni prostor automatski postaje Menadžer, dok se korisnicima koji se pridruže putem pozivne poveznice automatski dodjeljuje uloga Člana.';

  @override
  String get workspaceUsersManagementUsersGuideManagerRoleTitle =>
      'Uloga Menadžera';

  @override
  String get workspaceUsersManagementUsersGuideManagerRoleBody =>
      'Menadžer ima potpunu administrativnu i upravljačku kontrolu nad svime u radnom prostoru. Može pozivati Članove tima, stvarati Virtualne profile, uklanjati bilo kojeg korisnika iz radnog prostora te mijenjati uloge drugim Članovima tima (uključujući promicanje Člana u Menadžera ili degradiranje drugog Menadžera).';

  @override
  String get workspaceUsersManagementUsersGuideMemberRoleTitle => 'Uloga Člana';

  @override
  String get workspaceUsersManagementUsersGuideMemberRoleBody =>
      'Član tima s ulogom \'Član\' ima pristup samo za čitanje (\'read-only\'), što mu omogućuje da vidi sve zadatke, ciljeve i ostali sadržaj, ali ne i da njima upravlja. Za razliku od njega, Virtualni profil, koji uvijek ima ovu ulogu, ne može se prijaviti i služi isključivo kao placeholder kojemu Menadžer dodjeljuje zadatke.';

  @override
  String get workspaceUsersManagementCreate => 'Novi korisnik radnog prostora';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteDescription =>
      'Pozovite nove korisnike u ovaj radni prostor slanjem donje poveznice za pozivnicu:';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteLabel =>
      'Pozivni link radnog prostora';

  @override
  String get workspaceUsersManagementCreateVirtualUserDescription =>
      'Kreirajte novog virtualnog korisnika:';

  @override
  String get workspaceUsersManagementCreateVirtualUserSubmit =>
      'Kreiraj virtualnog korisnika';

  @override
  String get workspaceUsersManagementCreateVirtualUserSuccess =>
      'Uspješno ste kreirali virtualnog korisnika';

  @override
  String get workspaceUsersManagementCreateVirtualUserError =>
      'Uh-oh! Došlo je do problema prilikom kreiranja virtualnog korisnika';

  @override
  String get workspaceUsersManagementUserDetails =>
      'Detalji korisnika radnog prostora';

  @override
  String get workspaceUserFirstNameLabel => 'Ime';

  @override
  String get workspaceUserLastNameLabel => 'Prezime';

  @override
  String get orSeparator => 'ILI';
}
