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
  String get signInSubtitle =>
      'Organize routines, motivate children, and celebrate every win.';

  @override
  String get signInGetStarted => 'Let\'s get started';

  @override
  String get signInViaGoogle => 'Sign in via Google';

  @override
  String get signInGoogleCanceled =>
      'Google sign-in cancelled. Please try again.';

  @override
  String get somethingWentWrong => 'Uh-oh! Something went wrong';

  @override
  String get tryAgain => 'Try again';

  @override
  String get errorWhileLoadingWorkspaces =>
      'Uh-oh! We\'ve had some trouble loading up your workspaces';

  @override
  String get tasksLabel => 'Tasks';

  @override
  String get leaderboardLabel => 'Leaderboard';

  @override
  String get goalsLabel => 'Goals';

  @override
  String get workspaceNameLabel => 'Workspace name';

  @override
  String get workspaceDescriptionLabel => 'Workspace description';

  @override
  String get workspaceCreateTitle => 'Let\'s create a new workspace';

  @override
  String workspaceCreateSubtitle(Object email) {
    return 'We couldn\'t find existing workspaces for $email. If that\'s a mistake, try asking workspace owner for an invite link.';
  }

  @override
  String get workspaceCreateLabel => 'Create workspace';

  @override
  String get workspaceCreateNameMinLength =>
      'Name must have at least 3 characters';

  @override
  String get workspaceCreateNameMaxLength =>
      'Name can have at most 50 characters';

  @override
  String get workspaceCreateDescriptionMaxLength =>
      'Description can have at most 250 characters';

  @override
  String get requiredField => 'This field is required';

  @override
  String get errorWhileCreatingWorkspace =>
      'Uh-oh! We\'ve had some trouble creating your workspace';
}
