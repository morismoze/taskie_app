import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_hr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('hr'),
  ];

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @signInTitleStart.
  ///
  /// In en, this message translates to:
  /// **'Happy Chores, Happy Kids.'**
  String get signInTitleStart;

  /// No description provided for @signInTitleEnd.
  ///
  /// In en, this message translates to:
  /// **'Happy Home.'**
  String get signInTitleEnd;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Organize routines, motivate children, and celebrate every win.'**
  String get signInSubtitle;

  /// No description provided for @signInGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get signInGetStarted;

  /// No description provided for @signInViaGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in via Google'**
  String get signInViaGoogle;

  /// No description provided for @signInGoogleCanceled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in cancelled. Please try again.'**
  String get signInGoogleCanceled;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get tryAgain;

  /// No description provided for @errorOnInitialLoad.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble loading up your workspace'**
  String get errorOnInitialLoad;

  /// No description provided for @bottomNavigationBarTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get bottomNavigationBarTasksLabel;

  /// No description provided for @bottomNavigationBarLeaderboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get bottomNavigationBarLeaderboardLabel;

  /// No description provided for @bottomNavigationBarGoalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get bottomNavigationBarGoalsLabel;

  /// No description provided for @taskCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create new task'**
  String get taskCreateNew;

  /// No description provided for @goalCreateNew.
  ///
  /// In en, this message translates to:
  /// **'Create new goal'**
  String get goalCreateNew;

  /// No description provided for @workspaceNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace name'**
  String get workspaceNameLabel;

  /// No description provided for @workspaceDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace description'**
  String get workspaceDescriptionLabel;

  /// No description provided for @workspaceCreateTitle.
  ///
  /// In en, this message translates to:
  /// **'Let\'s create a new workspace'**
  String get workspaceCreateTitle;

  /// No description provided for @workspaceCreateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'We couldn\'t find existing workspaces for {email}. If that\'s a mistake, try asking workspace owner for an invite link.'**
  String workspaceCreateSubtitle(Object email);

  /// No description provided for @workspaceCreateLabel.
  ///
  /// In en, this message translates to:
  /// **'Create workspace'**
  String get workspaceCreateLabel;

  /// No description provided for @workspaceCreateNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must have at least 3 characters'**
  String get workspaceCreateNameMinLength;

  /// No description provided for @workspaceCreateNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name can have at most 50 characters'**
  String get workspaceCreateNameMaxLength;

  /// No description provided for @workspaceCreateDescriptionMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Description can have at most 250 characters'**
  String get workspaceCreateDescriptionMaxLength;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get requiredField;

  /// No description provided for @optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get optional;

  /// No description provided for @errorWhileCreatingWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating your workspace'**
  String get errorWhileCreatingWorkspace;

  /// No description provided for @tasksHello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get tasksHello;

  /// No description provided for @appDrawerTitle.
  ///
  /// In en, this message translates to:
  /// **'Workspaces'**
  String get appDrawerTitle;

  /// No description provided for @appDrawerChangeActiveWorkspaceError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble changing workspace'**
  String get appDrawerChangeActiveWorkspaceError;

  /// No description provided for @appDrawerEditWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace setttings'**
  String get appDrawerEditWorkspace;

  /// No description provided for @appDrawerManageUsers.
  ///
  /// In en, this message translates to:
  /// **'Workspace users'**
  String get appDrawerManageUsers;

  /// No description provided for @appDrawerNotActiveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'To see additional options, make this workspace active by clicking on its icon in the top list.'**
  String get appDrawerNotActiveWorkspace;

  /// No description provided for @appDrawerLeaveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Leave workspace'**
  String get appDrawerLeaveWorkspace;

  /// No description provided for @appDrawerLeaveWorkspaceModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this workspace?'**
  String get appDrawerLeaveWorkspaceModalMessage;

  /// No description provided for @appDrawerLeaveWorkspaceModalCta.
  ///
  /// In en, this message translates to:
  /// **'Leave'**
  String get appDrawerLeaveWorkspaceModalCta;

  /// No description provided for @appDrawerLeaveWorkspaceSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully left the workspace'**
  String get appDrawerLeaveWorkspaceSuccess;

  /// No description provided for @appDrawerLeaveWorkspaceError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble removing you from the workspace'**
  String get appDrawerLeaveWorkspaceError;

  /// No description provided for @appDrawerCreateNewWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Create new workspace'**
  String get appDrawerCreateNewWorkspace;

  /// No description provided for @appDrawerPreferences.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get appDrawerPreferences;

  /// No description provided for @createNewTaskNoMembers.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any members to assign a task to yet. Try inviting someone or creating virtual members.'**
  String get createNewTaskNoMembers;

  /// No description provided for @createNewTaskNoMembersCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add members'**
  String get createNewTaskNoMembersCta;

  /// No description provided for @createNewTaskTitle.
  ///
  /// In en, this message translates to:
  /// **'New task'**
  String get createNewTaskTitle;

  /// No description provided for @taskTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Task title'**
  String get taskTitleLabel;

  /// No description provided for @taskDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Task description'**
  String get taskDescriptionLabel;

  /// No description provided for @taskAssigneeLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get taskAssigneeLabel;

  /// No description provided for @taskDueDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Due date'**
  String get taskDueDateLabel;

  /// No description provided for @taskRewardPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Reward points'**
  String get taskRewardPointsLabel;

  /// No description provided for @taskTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Name must have at least 3 characters'**
  String get taskTitleMinLength;

  /// No description provided for @taskTitleMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name can have at most 50 characters'**
  String get taskTitleMaxLength;

  /// No description provided for @taskDescriptionMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Name can have at most 250 characters'**
  String get taskDescriptionMaxLength;

  /// No description provided for @taskAssigneesMinLength.
  ///
  /// In en, this message translates to:
  /// **'Task must have at least 1 assignee'**
  String get taskAssigneesMinLength;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @workspaceUsersManagement.
  ///
  /// In en, this message translates to:
  /// **'Users management'**
  String get workspaceUsersManagement;

  /// No description provided for @workspaceUsersManagementLoadUsersError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble loading up workspace users'**
  String get workspaceUsersManagementLoadUsersError;

  /// No description provided for @workspaceUsersManagementDeleteUser.
  ///
  /// In en, this message translates to:
  /// **'Remove user from workspace'**
  String get workspaceUsersManagementDeleteUser;

  /// No description provided for @workspaceUsersManagementDeleteUserModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this workspace user?'**
  String get workspaceUsersManagementDeleteUserModalMessage;

  /// No description provided for @workspaceUsersManagementDeleteUserModalCta.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get workspaceUsersManagementDeleteUserModalCta;

  /// No description provided for @workspaceUsersManagementDeleteUserSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully removed user from the workspace'**
  String get workspaceUsersManagementDeleteUserSuccess;

  /// No description provided for @workspaceUsersManagementDeleteUserError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble removing user from the workspace'**
  String get workspaceUsersManagementDeleteUserError;

  /// No description provided for @workspaceUsersManagementUsersGuideMainTitle.
  ///
  /// In en, this message translates to:
  /// **'About Workspace Users'**
  String get workspaceUsersManagementUsersGuideMainTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideIntroBody.
  ///
  /// In en, this message translates to:
  /// **'All participants in a workspace are categorized into two main types: Team Members (who have their own app account) and Virtual Profiles (which are placeholders managed by Managers). Each user is then assigned a role that defines their permissions.'**
  String get workspaceUsersManagementUsersGuideIntroBody;

  /// No description provided for @workspaceUsersManagementUsersGuideTeamMembersTitle.
  ///
  /// In en, this message translates to:
  /// **'Team Members (Real Users)'**
  String get workspaceUsersManagementUsersGuideTeamMembersTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideTeamMembersBody.
  ///
  /// In en, this message translates to:
  /// **'Team Members are users with their own account who can log in to the application. They either create a workspace (becoming a Manager automatically) or join one using an invitation link (becoming a Member automatically). The roles of Team Members can be changed by a Manager.'**
  String get workspaceUsersManagementUsersGuideTeamMembersBody;

  /// No description provided for @workspaceUsersManagementUsersGuideVirtualProfilesTitle.
  ///
  /// In en, this message translates to:
  /// **'Virtual Profiles'**
  String get workspaceUsersManagementUsersGuideVirtualProfilesTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideVirtualProfilesBody.
  ///
  /// In en, this message translates to:
  /// **'Virtual Profiles are placeholders for individuals who do not have an app account, such as children. They cannot log in. They can only be created by Managers and are always assigned the \'Member\' role, which cannot be changed.'**
  String get workspaceUsersManagementUsersGuideVirtualProfilesBody;

  /// No description provided for @workspaceUsersManagementUsersGuideRolesTitle.
  ///
  /// In en, this message translates to:
  /// **'User Roles: Manager and Member'**
  String get workspaceUsersManagementUsersGuideRolesTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideRolesBody.
  ///
  /// In en, this message translates to:
  /// **'Each user in the workspace is assigned one of two roles. The user who creates a workspace automatically becomes a Manager. Users who join via an invite link are automatically assigned the Member role.'**
  String get workspaceUsersManagementUsersGuideRolesBody;

  /// No description provided for @workspaceUsersManagementUsersGuideManagerRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Manager Role'**
  String get workspaceUsersManagementUsersGuideManagerRoleTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideManagerRoleBody.
  ///
  /// In en, this message translates to:
  /// **'Managers have full administrative and management control over everything in the workspace. They can invite Team Members, create Virtual Profiles, remove any user from the workspace, and change the roles of other Team Members (including promoting a Member to a Manager or demoting another Manager).'**
  String get workspaceUsersManagementUsersGuideManagerRoleBody;

  /// No description provided for @workspaceUsersManagementUsersGuideMemberRoleTitle.
  ///
  /// In en, this message translates to:
  /// **'Member Role'**
  String get workspaceUsersManagementUsersGuideMemberRoleTitle;

  /// No description provided for @workspaceUsersManagementUsersGuideMemberRoleBody.
  ///
  /// In en, this message translates to:
  /// **'A Team Member with the \'Member\' role has read-only access, allowing them to view all tasks, goals, and other content, but they cannot manage them. In contrast, a Virtual Profile, which always has this role, cannot log in and serves only as a placeholder for task assignment by a Manager.'**
  String get workspaceUsersManagementUsersGuideMemberRoleBody;

  /// No description provided for @workspaceUsersManagementCreate.
  ///
  /// In en, this message translates to:
  /// **'New workspace user'**
  String get workspaceUsersManagementCreate;

  /// No description provided for @workspaceUsersManagementCreateWorkspaceInviteDescription.
  ///
  /// In en, this message translates to:
  /// **'Invite new users to this workspace by sending them the invite link below:'**
  String get workspaceUsersManagementCreateWorkspaceInviteDescription;

  /// No description provided for @workspaceUsersManagementCreateWorkspaceInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace invite link'**
  String get workspaceUsersManagementCreateWorkspaceInviteLabel;

  /// No description provided for @note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get note;

  /// No description provided for @workspaceUsersManagementCreateWorkspaceInviteNote.
  ///
  /// In en, this message translates to:
  /// **'Each link is single-use (send it to one user only). You can copy it to the clipboard or share it. For your convenience, after either of those two actions, a new link is generated for new usage.'**
  String get workspaceUsersManagementCreateWorkspaceInviteNote;

  /// No description provided for @workspaceUsersManagementCreateWorkspaceInviteClipboard.
  ///
  /// In en, this message translates to:
  /// **'Successfully copied to clipboard'**
  String get workspaceUsersManagementCreateWorkspaceInviteClipboard;

  /// No description provided for @workspaceUsersManagementCreateVirtualUserDescription.
  ///
  /// In en, this message translates to:
  /// **'Create a new virtual user:'**
  String get workspaceUsersManagementCreateVirtualUserDescription;

  /// No description provided for @workspaceUserFirstNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'First name must have at least 2 characters'**
  String get workspaceUserFirstNameMinLength;

  /// No description provided for @workspaceUserFirstNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'First name can have at most 50 characters'**
  String get workspaceUserFirstNameMaxLength;

  /// No description provided for @workspaceUserLastNameMinLength.
  ///
  /// In en, this message translates to:
  /// **'Last name must have at least 2 characters'**
  String get workspaceUserLastNameMinLength;

  /// No description provided for @workspaceUserLastNameMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Last name can have at most 50 characters'**
  String get workspaceUserLastNameMaxLength;

  /// No description provided for @workspaceUsersManagementCreateVirtualUserSubmit.
  ///
  /// In en, this message translates to:
  /// **'Create new virtual user'**
  String get workspaceUsersManagementCreateVirtualUserSubmit;

  /// No description provided for @workspaceUsersManagementCreateVirtualUserSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully created virtual user'**
  String get workspaceUsersManagementCreateVirtualUserSuccess;

  /// No description provided for @workspaceUsersManagementCreateVirtualUserError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating virtual user'**
  String get workspaceUsersManagementCreateVirtualUserError;

  /// No description provided for @workspaceUsersManagementUserDetails.
  ///
  /// In en, this message translates to:
  /// **'Workspace user details'**
  String get workspaceUsersManagementUserDetails;

  /// No description provided for @workspaceUsersManagementUserDetailsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit workspace user details'**
  String get workspaceUsersManagementUserDetailsEdit;

  /// No description provided for @workspaceUsersManagementUserDetailsEditNote.
  ///
  /// In en, this message translates to:
  /// **'Be cautious when changing a user\'s role. Users with the Manager role have full administrative and managerial control over the workspace.'**
  String get workspaceUsersManagementUserDetailsEditNote;

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @workspaceUsersManagementUserDetailsEditSubmit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get workspaceUsersManagementUserDetailsEditSubmit;

  /// No description provided for @workspaceUserFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First name'**
  String get workspaceUserFirstNameLabel;

  /// No description provided for @workspaceUserLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Last name'**
  String get workspaceUserLastNameLabel;

  /// No description provided for @orSeparator.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get orSeparator;

  /// No description provided for @createdBy.
  ///
  /// In en, this message translates to:
  /// **'Created by'**
  String get createdBy;

  /// No description provided for @createdAt.
  ///
  /// In en, this message translates to:
  /// **'Created at'**
  String get createdAt;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'hr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'hr':
      return AppLocalizationsHr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
