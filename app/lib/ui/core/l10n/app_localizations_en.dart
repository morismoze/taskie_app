// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get cancel => 'Cancel';

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
  String get bottomNavigationBarTasksLabel => 'Tasks';

  @override
  String get bottomNavigationBarLeaderboardLabel => 'Leaderboard';

  @override
  String get bottomNavigationBarGoalsLabel => 'Goals';

  @override
  String get taskCreateNew => 'Create new task';

  @override
  String get goalCreateNew => 'Create new goal';

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
  String get optional => 'optional';

  @override
  String get errorWhileCreatingWorkspace =>
      'Uh-oh! We\'ve had some trouble creating your workspace';

  @override
  String get tasksHello => 'Hello!';

  @override
  String get appDrawerTitle => 'Workspaces';

  @override
  String get appDrawerEditWorkspace => 'Edit workspace setttings';

  @override
  String get appDrawerInviteMembers => 'Invite new members';

  @override
  String get appDrawerLeaveWorkspace => 'Leave workspace';

  @override
  String get appDrawerLeaveWorkspaceModalMessage =>
      'Are you sure you want to leave this workspace?';

  @override
  String get appDrawerLeaveWorkspaceModalCta => 'Leave';

  @override
  String get appDrawerLeaveWorkspaceSuccess =>
      'Successfully left the workspace';

  @override
  String get appDrawerLeaveWorkspaceError =>
      'Uh-oh! We\'ve had some trouble removing you from the workspace';

  @override
  String get appDrawerCreateNewWorkspace => 'Create new workspace';

  @override
  String get appDrawerPreferences => 'Preferences';

  @override
  String get createNewTaskTitle => 'New task';

  @override
  String get taskNameLabel => 'Task name';

  @override
  String get taskDescriptionLabel => 'Task description';

  @override
  String get taskAssigneeLabel => 'Assign to';

  @override
  String get taskDueDateLabel => 'Due date';

  @override
  String get taskRewardPointsLabel => 'Reward points';

  @override
  String get taskNameMinLength => 'Name must have at least 3 characters';

  @override
  String get taskNameMaxLength => 'Name can have at most 50 characters';

  @override
  String get taskDescriptionMaxLength => 'Name can have at most 250 characters';
}
