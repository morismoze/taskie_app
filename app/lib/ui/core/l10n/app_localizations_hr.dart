// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Croatian (`hr`).
class AppLocalizationsHr extends AppLocalizations {
  AppLocalizationsHr([String locale = 'hr']) : super(locale);

  @override
  String get misc_cancel => 'Otkaži';

  @override
  String get misc_somethingWentWrong => 'Uh-oh! Nešto je pošlo po zlu';

  @override
  String get misc_tryAgain => 'Pokušajte ponovno';

  @override
  String get misc_requiredField => 'Ovo polje je obvezno';

  @override
  String get misc_optional => 'opcionalno';

  @override
  String get misc_submit => 'Potvrdi';

  @override
  String get misc_close => 'Zatvori';

  @override
  String get misc_note => 'Napomena';

  @override
  String get misc_roleManager => 'Menadžer';

  @override
  String get misc_roleMember => 'Član';

  @override
  String get misc_ok => 'U redu';

  @override
  String get misc_comingSoon => 'Uskoro';

  @override
  String get misc_profile => 'Profil';

  @override
  String get misc_new => 'Novo';

  @override
  String get misc_goToHomepage => 'Idi na Početnu stranicu';

  @override
  String get signInTitleStart => 'Organizirajte zadatke, ostvarite ciljeve.';

  @override
  String get signInTitleEnd => 'Uspješno.';

  @override
  String get signInSubtitle =>
      'Učinkovito upravljajte obavezama, potaknite angažman i proslavite svaki uspjeh.';

  @override
  String get signInGetStarted => 'Započnimo';

  @override
  String get signInViaGoogle => 'Prijavi se putem Googlea';

  @override
  String get signInGoogleCanceled =>
      'Google prijava otkazana. Molimo pokušajte ponovno.';

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
  String get taskCreateNew => 'Kreiraj novi zadatak';

  @override
  String get goalCreateNew => 'Kreiraj novi cilj';

  @override
  String get workspaceNameLabel => 'Naziv radnog prostora';

  @override
  String get workspaceDescriptionLabel => 'Opis radnog prostora';

  @override
  String get workspaceCreateTitle => 'Kreirajmo novi radni prostor';

  @override
  String workspaceCreateSubtitle(Object email) {
    return 'Nismo pronašli postojeće radne prostore za $email. Ako je to greška, pokušajte zamoliti vlasnika radnog prostora za pozivni link.';
  }

  @override
  String get workspaceCreateLabel => 'Kreiraj radni prostor';

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
  String get workspaceCreateError =>
      'Uh-oh! Došlo je do problema prilikom kreiranja radnog prostora';

  @override
  String get tasksHello => 'Pozdrav!';

  @override
  String get taskskNoTasks =>
      'Izgleda da vaš radni prostor još nema nijedan zadatak. Pokušajte kreirati prvi!';

  @override
  String get taskskNoFilteredTasks =>
      'Uh-oh! Čini se da nema zadataka za odabrane filtre. Pokušajte s drugačijima!';

  @override
  String get objectiveStatusFilterAll => 'Svi statusi';

  @override
  String get progressStatusInProgress => 'U tijeku';

  @override
  String get progressStatusCompleted => 'Dovršeno';

  @override
  String get progressStatusCompletedAsStale => 'Dovršeno (zastarjelo)';

  @override
  String get progressStatusNotCompleted => 'Nedovršeno';

  @override
  String get progressStatusClosed => 'Zatvoreno';

  @override
  String get sortByNewest => 'Najnoviji';

  @override
  String get sortByOldest => 'Najstariji';

  @override
  String tasksCardPoints(Object points) {
    return '$points bodova';
  }

  @override
  String get tasksDetails => 'Detalji zadatka';

  @override
  String get tasksDetailsEdit => 'Uređivanje detalja zadatka';

  @override
  String get tasksDetailsEditCreatedBy => 'Zadatak kreirao/la';

  @override
  String get tasksDetailsEditCreatedByDeletedAccount =>
      'Kreator je izbrisao račun';

  @override
  String get tasksDetailsEditCreatedAt => 'Zadatak kreiran';

  @override
  String get tasksDetailsEditSuccess => 'Uspješno ste uredili detalje zadatka';

  @override
  String get tasksDetailsEditError =>
      'Uh-oh! Došlo je do problema prilikom uređivanja detalja zadatka';

  @override
  String get updateTaskAssignmentsSuccess =>
      'Uspješno ste ažurirali dodjele zadatka';

  @override
  String get updateTaskAssignmentsUpdateError =>
      'Uh-oh! Došlo je do problema prilikom ažuriranja dodjela zadatka';

  @override
  String get addTaskAssignmentSuccess =>
      'Uspješno ste dodjelili zadatak odabranome članu';

  @override
  String get addTaskAssignmentError =>
      'Uh-oh! Došlo je do problema prilikom dodjeljivanja zadatka članu';

  @override
  String get closedTaskError =>
      'Uh-oh! Izgleda da je ovaj zadatak zatvoren. Ažuriranje njegovih detalja i dodjela više nije moguće. Molimo, odite na početnu stranicu i osvježite svoj popis zadatakaa.';

  @override
  String get removeTaskAssignmentModalMessage =>
      'Jeste li sigurni da želite ukloniti ovog korisnika iz dodjele zadatka?';

  @override
  String get removeTaskAssignmentModalCta => 'Ukloni';

  @override
  String get removeTaskAssignmentSuccess =>
      'Uspješno ste uklonili dodjelu s odabranoga člana';

  @override
  String get removeTaskAssignmentError =>
      'Uh-oh! Došlo je do problema prilikom uklanjanja dodjele s člana';

  @override
  String get tasksDetailsCloseTask => 'Zatvori zadatak';

  @override
  String get tasksDetailsCloseTaskModalMessage =>
      'Jeste li sigurni da želite zatvoriti ovaj zadatak?\nKada zatvorite zadatak, zadatak će se zatvoriti za sve dodijeljene članove.\nDodatno, neće ga više biti moguće ažurirati.';

  @override
  String get tasksDetailsCloseSuccess => 'Uspješno ste zatvorili zadatak';

  @override
  String get tasksDetailsCloseError =>
      'Uh-oh! Došlo je do problema prilikom zatvaranja zadatka';

  @override
  String get tasksAssignmentsEdit => 'Uređivanje dodjela zadatka';

  @override
  String get tasksAssignmentsEditStatusLabel => 'Status';

  @override
  String get tasksAssignmentsEditStatusSubmit => 'Ažuriraj dodjele';

  @override
  String get tasksAssignmentsEditAddNewAssignee =>
      'Dodijelite ovaj zadatak dodatnome članu:';

  @override
  String get tasksAssignmentsGuideMainTitle => 'O dodjelama zadatka';

  @override
  String get tasksAssignmentsGuideAssignmentLimitTitle =>
      'Ograničenje broja dodjela';

  @override
  String get tasksAssignmentsGuideAssignmentLimitBody =>
      'Svaki zadatak može imati do __10 dodijeljenih članova__.\nUkoliko želite ukloniti neke od dodjela, možete to napraviti klikom na ikonicu **X** pored same dodjele.\nNove članove možete dodijeliti trenutnom zadatku koristeći formu na dnu.';

  @override
  String get tasksAssignmentsGuideAssignmentStatusesTitle => 'Statusi dodjela';

  @override
  String get tasksAssignmentsGuideAssignmentStatusesBody =>
      '__In Progress__ - zadatak je trenutno u izradi\n__Completed__ - zadatak je uspješno završen\n__Completed as Stale__ - zadatak je završen nakon isteka roka završetka (primjenjivo samo ako zadatak ima postavljen Rok završetka)\n__Not Completed__ - zadatak nije izvršen';

  @override
  String get tasksAssignmentsGuideMultipleAssigneesTitle =>
      'Višestruke dodjele';

  @override
  String get tasksAssignmentsGuideMultipleAssigneesBody =>
      'Jedan zadatak može biti dodijeljen većem broju članova iz dva razloga:\n\n__Individualni rad__ - kada želite da više članova radi na istom zadatku samostalno, bez potrebe za stvaranjem duplikata zadatka za svakog člana. Svaki član radi individualno i dobiva iste nagradne bodove.\n\n__Timski rad__ - kada više članova zajednički radi na istom zadatku kao tim. Svaki član također dobiva iste nagradne bodove po završetku.\n\nU oba slučaja, svaki dodijeljeni član dobiva isti broj nagradnih bodova koji je postavljen za zadatak.';

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
  String get appDrawerCreateNewWorkspace => 'Kreiraj novi radni prostor';

  @override
  String get preferencesLabel => 'Preference';

  @override
  String get createNewTaskNoMembers =>
      'Čini se da vaš radni prostor još nema nijednog člana kojemu se može dodijeliti zadatak. Pokušajte pozvati nekoga ili kreirati virtualne članove.';

  @override
  String get objectiveNoMembersCta => 'Dodajmo članove';

  @override
  String get createNewTaskTitle => 'Novi zadatak';

  @override
  String get taskTitleLabel => 'Naslov zadatka';

  @override
  String get taskDescriptionLabel => 'Opis zadatka';

  @override
  String get objectiveAssigneeLabel => 'Dodijeli članu';

  @override
  String get taskDueDateLabel => 'Rok završetka';

  @override
  String get taskRewardPointsLabel => 'Nagradni bodovi';

  @override
  String get objectiveTitleMinLength => 'Naslov mora imati najmanje 3 znaka';

  @override
  String get objectiveTitleMaxLength => 'Naslov može imati najviše 50 znakova';

  @override
  String get objectiveDescriptionMaxLength =>
      'Opis može imati najviše 250 znakova';

  @override
  String get taskAssigneesMinLength =>
      'Zadatak mora biti dodijeljen barem 1 članu';

  @override
  String get workspaceUsersManagement => 'Upravljanje korisnicima';

  @override
  String get workspaceUsersManagementLoadUsersError =>
      'Uh-oh! Došlo je do problema prilikom dohvata korisnika radnog prostora';

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
      'Svakom korisniku u radnom prostoru dodijeljena je jedna od dvije uloge. Korisnik koji kreira radni prostor automatski postaje Menadžer, dok se korisnicima koji se pridruže putem pozivne poveznice automatski dodjeljuje uloga Člana.';

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
  String get workspaceInviteLabel => 'Pozivni link radnog prostora';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteNote =>
      'Svaki link je jednokratan (pošaljite ga samo jednom korisniku). Možete ga kopirati u međuspremnik ili podijeliti. Radi vaše praktičnosti, nakon bilo koje od tih radnji, generira se novi link za iduću upotrebu.';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteClipboard =>
      'Uspješno kopirano u međuspremnik';

  @override
  String get workspaceUsersManagementCreateVirtualUserDescription =>
      'Kreirajte novog virtualnog korisnika:';

  @override
  String get workspaceUserFirstNameMinLength =>
      'Ime mora imati najmanje 2 znaka';

  @override
  String get workspaceUserFirstNameMaxLength =>
      'Ime može imati najviše 50 znakova';

  @override
  String get workspaceUserLastNameMinLength =>
      'Prezime mora imati najmanje 2 znaka';

  @override
  String get workspaceUserLastNameMaxLength =>
      'Prezime može imati najviše 50 znakova';

  @override
  String get workspaceUsersManagementCreateVirtualUserSubmit =>
      'Kreiraj novog virtualnog korisnika';

  @override
  String get workspaceUsersManagementCreateVirtualUserSuccess =>
      'Uspješno ste kreirali virtualnog korisnika';

  @override
  String get workspaceUsersManagementCreateVirtualUserError =>
      'Uh-oh! Došlo je do problema prilikom kreiranja virtualnog korisnika';

  @override
  String get workspaceUsersManagementUserDetails => 'Korisnički detalji';

  @override
  String get workspaceUsersManagementUserDetailsEdit =>
      'Uređivanje korisničkih podataka';

  @override
  String get workspaceUsersManagementUserDetailsEditNote =>
      'Budite oprezni prilikom izmjene uloge korisnika u Menadžer ulogu. Korisnici s ulogom Menadžer imaju potpunu administrativnu i upravljačku kontrolu nad radnim prostorom.';

  @override
  String get workspaceUsersManagementUserDetailsEditFirstNameBlocked =>
      'Uređivanje imena ne-virtualnih korisnika nije moguće jer to polje dolazi od pružatelja prijave (npr. Google) korištenog za ovu aplikaciju.';

  @override
  String get workspaceUsersManagementUserDetailsEditLastNameBlocked =>
      'Uređivanje prezimena ne-virtualnih korisnika nije moguće jer to polje dolazi od pružatelja prijave (npr. Google) korištenog za ovu aplikaciju.';

  @override
  String get workspaceUsersManagementUserDetailsEditRoleBlocked =>
      'Virtualnim korisnicima je uvijek dodijeljena uloga Člana i nije ju moguće promijeniti.';

  @override
  String get editDetailsSubmit => 'Uredi detalje';

  @override
  String get workspaceUsersManagementUserDetailsEditSuccess =>
      'Uspješno ste uredili podatke korisnika';

  @override
  String get workspaceUsersManagementUserDetailsEditError =>
      'Uh-oh! Došlo je do problema prilikom uređivanja korisničkih podataka';

  @override
  String get workspaceUserFirstNameLabel => 'Ime';

  @override
  String get workspaceUserLastNameLabel => 'Prezime';

  @override
  String get roleLabel => 'Uloga';

  @override
  String get workspaceUsersManagementUserDetailsCreatedBy =>
      'Korisnika kreirao/la';

  @override
  String get workspaceUsersManagementUserDetailsCreatedAt => 'Korisnik kreiran';

  @override
  String get createNewGoalNoMembers =>
      'Čini se da vaš radni prostor još nema nijednog člana kojemu se može dodijeliti cilj. Pokušajte pozvati nekoga ili kreirati virtualne članove.';

  @override
  String get createNewGoalTitle => 'Novi cilj';

  @override
  String get goalTitleLabel => 'Naslov cilja';

  @override
  String get goalDescriptionLabel => 'Opis cilja';

  @override
  String get goalRequiredPointsCurrentAccumulatedPoints =>
      'Trenutno akumulirani bodovi korisnika';

  @override
  String get goalRequiredPointsLabel => 'Potrebni bodovi';

  @override
  String get goalRequiredPointsNote =>
      'Potrebni bodovi predstavljaju ukupan broj nagradnih bodova koje član treba akumulirati rješavanjem zadataka kako bi dosegao cilj. Budući da zadaci daju bodove u koracima od 10 (10, 20, 30, 40, 50), potrebni bodovi također moraju biti višekratnik broja 10 (npr. 50, 550, 5660, 25340, 30000).';

  @override
  String get createNewGoalRequiredPointsNaN =>
      'Potrebni bodovi moraju biti broj bez znakova';

  @override
  String get createNewGoalRequiredPointsNotMultipleOf10 =>
      'Potrebni bodovi moraju biti višekratnik broja 10';

  @override
  String get goalAssigneesRequired => 'Cilj mora biti dodijeljen 1 članu';

  @override
  String get workspaceSettings => 'Postavke radnog prostora';

  @override
  String get workspaceSettingsOwnerDeletedAccount =>
      'Vlasnik je izbrisao račun';

  @override
  String get workspaceSettingsCreatedBy => 'Radni prostor kreirao/la';

  @override
  String get workspaceSettingsCreatedAt => 'Radni prostor kreiran';

  @override
  String get workspaceSettingsEdit => 'Uređivanje detalja radnog prostora';

  @override
  String get workspaceSettingsEditSuccess =>
      'Uspješno ste uredili podatke radnog prostora';

  @override
  String get workspaceSettingsEditError =>
      'Uh-oh! Došlo je do problema prilikom uređivanja podataka radnog prostora';

  @override
  String get preferencesLocalization => 'Lokalizacija';

  @override
  String get preferencesLocalizationLanguage => 'Jezik';

  @override
  String get preferencesTheme => 'Tema';

  @override
  String get preferencesThemeDarkMode => 'Tamni način';

  @override
  String get preferencesThemeDarkModeOff => 'Isključeno';

  @override
  String get workspaceCreate => 'Novi radni prostor';

  @override
  String get workspaceCreateNewDescription => 'Kreirajte novi radni prostor:';

  @override
  String get workspaceCreateJoinViaInviteLinkDescription =>
      'Pridružite se putem pozivnog linka radnog prostora:';

  @override
  String workspaceCreateJoinViaInviteLinkNote(Object inviteLinkExample) {
    return 'Pozivni link mora biti u formatu\n$inviteLinkExample.';
  }

  @override
  String get workspaceCreateJoinViaInviteLinkSubmit =>
      'Pridruži se radnom prostoru';

  @override
  String get workspaceCreateJoinViaInviteLinkInvalid =>
      'Neispravan format pozivnog linka';

  @override
  String get workspaceCreateJoinViaInviteLinkNotFound =>
      'Uneseni pozivni link nije važeći';

  @override
  String get workspaceCreateJoinViaInviteLinkExpiredOrUsed =>
      'Uneseni pozivni link je istekao ili je već iskorišten';

  @override
  String get workspaceCreateJoinViaInviteLinkExistingUser =>
      'Već ste član ovog radnog prostora';

  @override
  String get workspaceCreationSuccess =>
      'Uspješno ste kreirali novi radni prostor';
}
