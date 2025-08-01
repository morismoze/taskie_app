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

  /// No description provided for @misc_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get misc_cancel;

  /// No description provided for @misc_somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! Something went wrong'**
  String get misc_somethingWentWrong;

  /// No description provided for @misc_tryAgain.
  ///
  /// In en, this message translates to:
  /// **'Try again'**
  String get misc_tryAgain;

  /// No description provided for @misc_requiredField.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get misc_requiredField;

  /// No description provided for @misc_optional.
  ///
  /// In en, this message translates to:
  /// **'optional'**
  String get misc_optional;

  /// No description provided for @misc_submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get misc_submit;

  /// No description provided for @misc_close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get misc_close;

  /// No description provided for @misc_note.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get misc_note;

  /// No description provided for @misc_roleManager.
  ///
  /// In en, this message translates to:
  /// **'Manager'**
  String get misc_roleManager;

  /// No description provided for @misc_roleMember.
  ///
  /// In en, this message translates to:
  /// **'Member'**
  String get misc_roleMember;

  /// No description provided for @misc_orSeparator.
  ///
  /// In en, this message translates to:
  /// **'or'**
  String get misc_orSeparator;

  /// No description provided for @misc_ok.
  ///
  /// In en, this message translates to:
  /// **'Ok'**
  String get misc_ok;

  /// No description provided for @misc_comingSoon.
  ///
  /// In en, this message translates to:
  /// **'Coming soon'**
  String get misc_comingSoon;

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

  /// No description provided for @workspaceCreateError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating your workspace'**
  String get workspaceCreateError;

  /// No description provided for @tasksHello.
  ///
  /// In en, this message translates to:
  /// **'Hello!'**
  String get tasksHello;

  /// No description provided for @tasksCardProgressInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get tasksCardProgressInProgress;

  /// No description provided for @tasksCardProgressCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get tasksCardProgressCompleted;

  /// No description provided for @tasksCardProgressCompletedAsStale.
  ///
  /// In en, this message translates to:
  /// **'Completed as Stale'**
  String get tasksCardProgressCompletedAsStale;

  /// No description provided for @tasksCardProgressClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get tasksCardProgressClosed;

  /// No description provided for @tasksCardPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String tasksCardPoints(Object points);

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

  /// No description provided for @preferencesLabel.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesLabel;

  /// No description provided for @createNewTaskNoMembers.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any members to assign a task to yet. Try inviting someone or creating virtual members.'**
  String get createNewTaskNoMembers;

  /// No description provided for @objectiveNoMembersCta.
  ///
  /// In en, this message translates to:
  /// **'Let\'s add members'**
  String get objectiveNoMembersCta;

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

  /// No description provided for @objectiveAssigneeLabel.
  ///
  /// In en, this message translates to:
  /// **'Assign to'**
  String get objectiveAssigneeLabel;

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

  /// No description provided for @objectiveTitleMinLength.
  ///
  /// In en, this message translates to:
  /// **'Title must have at least 3 characters'**
  String get objectiveTitleMinLength;

  /// No description provided for @objectiveTitleMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Title can have at most 50 characters'**
  String get objectiveTitleMaxLength;

  /// No description provided for @objectiveDescriptionMaxLength.
  ///
  /// In en, this message translates to:
  /// **'Description can have at most 250 characters'**
  String get objectiveDescriptionMaxLength;

  /// No description provided for @taskAssigneesMinLength.
  ///
  /// In en, this message translates to:
  /// **'Task must have at least 1 assignee'**
  String get taskAssigneesMinLength;

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

  /// No description provided for @workspaceInviteLabel.
  ///
  /// In en, this message translates to:
  /// **'Workspace invite link'**
  String get workspaceInviteLabel;

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
  /// **'Be cautious when changing a user\'s role to Manager role. Users with the Manager role have full administrative and managerial control over the workspace.'**
  String get workspaceUsersManagementUserDetailsEditNote;

  /// No description provided for @workspaceUsersManagementUserDetailsEditFirstNameBlocked.
  ///
  /// In en, this message translates to:
  /// **'Editing first name of non-virtual users is not possible because this field is provided by the sign-up provider (e.g., Google) used for this app.'**
  String get workspaceUsersManagementUserDetailsEditFirstNameBlocked;

  /// No description provided for @workspaceUsersManagementUserDetailsEditLastNameBlocked.
  ///
  /// In en, this message translates to:
  /// **'Editing last name of non-virtual users is not possible because this field is provided by the sign-up provider (e.g., Google) used for this app.'**
  String get workspaceUsersManagementUserDetailsEditLastNameBlocked;

  /// No description provided for @workspaceUsersManagementUserDetailsEditRoleBlocked.
  ///
  /// In en, this message translates to:
  /// **'Virtual users always have the Member role and cannot be changed.'**
  String get workspaceUsersManagementUserDetailsEditRoleBlocked;

  /// No description provided for @workspaceUsersManagementUserDetailsEditSubmit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get workspaceUsersManagementUserDetailsEditSubmit;

  /// No description provided for @workspaceUsersManagementUserDetailsEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited workspace user details'**
  String get workspaceUsersManagementUserDetailsEditSuccess;

  /// No description provided for @workspaceUsersManagementUserDetailsEditError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble editing workspace user details'**
  String get workspaceUsersManagementUserDetailsEditError;

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

  /// No description provided for @roleLabel.
  ///
  /// In en, this message translates to:
  /// **'Role'**
  String get roleLabel;

  /// No description provided for @workspaceUsersManagementUserDetailsCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'User created by'**
  String get workspaceUsersManagementUserDetailsCreatedBy;

  /// No description provided for @workspaceUsersManagementUserDetailsCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'User created at'**
  String get workspaceUsersManagementUserDetailsCreatedAt;

  /// No description provided for @createNewGoalNoMembers.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any members to assign a goal to yet. Try inviting someone or creating virtual members.'**
  String get createNewGoalNoMembers;

  /// No description provided for @createNewGoalTitle.
  ///
  /// In en, this message translates to:
  /// **'New goal'**
  String get createNewGoalTitle;

  /// No description provided for @goalTitleLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal title'**
  String get goalTitleLabel;

  /// No description provided for @goalDescriptionLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal description'**
  String get goalDescriptionLabel;

  /// No description provided for @goalRequiredPointsCurrentAccumulatedPoints.
  ///
  /// In en, this message translates to:
  /// **'Current accumulated points by the user'**
  String get goalRequiredPointsCurrentAccumulatedPoints;

  /// No description provided for @goalRequiredPointsLabel.
  ///
  /// In en, this message translates to:
  /// **'Required points'**
  String get goalRequiredPointsLabel;

  /// No description provided for @goalRequiredPointsNote.
  ///
  /// In en, this message translates to:
  /// **'Required points represent the total reward points a member needs to accumulate solving tasks to achieve a goal. Since tasks grant points in steps of 10 (10, 20, 30, 40, 50), the required points must also be a multiple of 10 (e.g. 50, 550, 5660, 25340, 30000).'**
  String get goalRequiredPointsNote;

  /// No description provided for @createNewGoalRequiredPointsNaN.
  ///
  /// In en, this message translates to:
  /// **'Required points must be a number without characters'**
  String get createNewGoalRequiredPointsNaN;

  /// No description provided for @createNewGoalRequiredPointsNotMultipleOf10.
  ///
  /// In en, this message translates to:
  /// **'Required points must be a multiple of 10'**
  String get createNewGoalRequiredPointsNotMultipleOf10;

  /// No description provided for @goalAssigneesRequired.
  ///
  /// In en, this message translates to:
  /// **'Goal must have 1 assignee'**
  String get goalAssigneesRequired;

  /// No description provided for @workspaceSettings.
  ///
  /// In en, this message translates to:
  /// **'Workspace settings'**
  String get workspaceSettings;

  /// No description provided for @workspaceSettingsOwnerDeletedAccount.
  ///
  /// In en, this message translates to:
  /// **'Owner deleted their account'**
  String get workspaceSettingsOwnerDeletedAccount;

  /// No description provided for @workspaceSettingsCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Workspace created by'**
  String get workspaceSettingsCreatedBy;

  /// No description provided for @workspaceSettingsCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Workspace created at'**
  String get workspaceSettingsCreatedAt;

  /// No description provided for @workspaceSettingsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit workspace details'**
  String get workspaceSettingsEdit;

  /// No description provided for @workspaceSettingsEditSubmit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get workspaceSettingsEditSubmit;

  /// No description provided for @workspaceSettingsEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited workspace details'**
  String get workspaceSettingsEditSuccess;

  /// No description provided for @workspaceSettingsEditError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble editing workspace details'**
  String get workspaceSettingsEditError;

  /// No description provided for @preferencesLocalization.
  ///
  /// In en, this message translates to:
  /// **'Localization'**
  String get preferencesLocalization;

  /// No description provided for @preferencesLocalizationLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get preferencesLocalizationLanguage;

  /// No description provided for @preferencesTheme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get preferencesTheme;

  /// No description provided for @preferencesThemeDarkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark mode'**
  String get preferencesThemeDarkMode;

  /// No description provided for @preferencesThemeDarkModeOff.
  ///
  /// In en, this message translates to:
  /// **'Off'**
  String get preferencesThemeDarkModeOff;

  /// No description provided for @workspaceCreate.
  ///
  /// In en, this message translates to:
  /// **'New workspace'**
  String get workspaceCreate;

  /// No description provided for @workspaceCreateNewDescription.
  ///
  /// In en, this message translates to:
  /// **'Create new workspace:'**
  String get workspaceCreateNewDescription;

  /// No description provided for @workspaceCreateJoinViaInviteLinkDescription.
  ///
  /// In en, this message translates to:
  /// **'Join via workspace invite link:'**
  String get workspaceCreateJoinViaInviteLinkDescription;

  /// No description provided for @workspaceCreateJoinViaInviteLinkNote.
  ///
  /// In en, this message translates to:
  /// **'The invite link must be in the format\n{inviteLinkExample}.'**
  String workspaceCreateJoinViaInviteLinkNote(Object inviteLinkExample);

  /// No description provided for @workspaceCreateJoinViaInviteLinkSubmit.
  ///
  /// In en, this message translates to:
  /// **'Join workspace'**
  String get workspaceCreateJoinViaInviteLinkSubmit;

  /// No description provided for @workspaceCreateJoinViaInviteLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'Invalid invite link format'**
  String get workspaceCreateJoinViaInviteLinkInvalid;

  /// No description provided for @workspaceCreateJoinViaInviteLinkNotFound.
  ///
  /// In en, this message translates to:
  /// **'The provided link is invalid'**
  String get workspaceCreateJoinViaInviteLinkNotFound;

  /// No description provided for @workspaceCreateJoinViaInviteLinkExpiredOrUsed.
  ///
  /// In en, this message translates to:
  /// **'The provided link has expired or was already used'**
  String get workspaceCreateJoinViaInviteLinkExpiredOrUsed;

  /// No description provided for @workspaceCreateJoinViaInviteLinkExistingUser.
  ///
  /// In en, this message translates to:
  /// **'You are already part of this workspace'**
  String get workspaceCreateJoinViaInviteLinkExistingUser;

  /// No description provided for @workspaceCreationSuccess.
  ///
  /// In en, this message translates to:
  /// **'You\'ve successfully created new workspace'**
  String get workspaceCreationSuccess;
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
