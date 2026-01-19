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

  /// No description provided for @misc_profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get misc_profile;

  /// No description provided for @misc_new.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get misc_new;

  /// No description provided for @misc_goToHomepage.
  ///
  /// In en, this message translates to:
  /// **'Go to Homepage'**
  String get misc_goToHomepage;

  /// No description provided for @misc_goToGoalsPage.
  ///
  /// In en, this message translates to:
  /// **'Go to Goals page'**
  String get misc_goToGoalsPage;

  /// No description provided for @misc_pointsAbbr.
  ///
  /// In en, this message translates to:
  /// **'pts'**
  String get misc_pointsAbbr;

  /// No description provided for @misc_errorPrompt.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve ran into a small hiccup loading this.'**
  String get misc_errorPrompt;

  /// No description provided for @misc_retry.
  ///
  /// In en, this message translates to:
  /// **'Let\'s try again'**
  String get misc_retry;

  /// No description provided for @misc_somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! Something went wrong'**
  String get misc_somethingWentWrong;

  /// No description provided for @misc_privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get misc_privacyPolicy;

  /// No description provided for @misc_termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get misc_termsAndConditions;

  /// No description provided for @misc_contactSupport.
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get misc_contactSupport;

  /// No description provided for @bootstrapError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble while starting up. Please try again or restart the app.'**
  String get bootstrapError;

  /// No description provided for @signInTitleStart.
  ///
  /// In en, this message translates to:
  /// **'Organize Tasks, Achieve Goals.'**
  String get signInTitleStart;

  /// No description provided for @signInTitleEnd.
  ///
  /// In en, this message translates to:
  /// **'Successfully.'**
  String get signInTitleEnd;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Effectively manage obligations, encourage engagement, and celebrate every success.'**
  String get signInSubtitle;

  /// No description provided for @signInGetStarted.
  ///
  /// In en, this message translates to:
  /// **'Let\'s get started'**
  String get signInGetStarted;

  /// No description provided for @signInLegislation1.
  ///
  /// In en, this message translates to:
  /// **'By signing in, you agree to our'**
  String get signInLegislation1;

  /// No description provided for @signInLegislation2.
  ///
  /// In en, this message translates to:
  /// **'Terms and Conditions'**
  String get signInLegislation2;

  /// No description provided for @signInLegislation3.
  ///
  /// In en, this message translates to:
  /// **'and'**
  String get signInLegislation3;

  /// No description provided for @signInLegislation4.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get signInLegislation4;

  /// No description provided for @signInTitleProviders.
  ///
  /// In en, this message translates to:
  /// **'Sign in method'**
  String get signInTitleProviders;

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

  /// No description provided for @signInGoogleError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble with Google sign-in'**
  String get signInGoogleError;

  /// No description provided for @errorOnInitialLoad.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble loading up your workspace.'**
  String get errorOnInitialLoad;

  /// No description provided for @bottomNavigationBarTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get bottomNavigationBarTasksLabel;

  /// No description provided for @leaderboardLabel.
  ///
  /// In en, this message translates to:
  /// **'Leaderboard'**
  String get leaderboardLabel;

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

  /// No description provided for @tasksNoTasks.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any tasks yet. Try creating your first one using the main **+** button below or refreshing the feed!'**
  String get tasksNoTasks;

  /// No description provided for @tasksLoadRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble refreshing the tasks'**
  String get tasksLoadRefreshError;

  /// No description provided for @taskskNoFilteredTasks.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like there aren\'t any tasks for the chosen filters. Try different ones!'**
  String get taskskNoFilteredTasks;

  /// No description provided for @tasksPressAgainToExit.
  ///
  /// In en, this message translates to:
  /// **'Press again to exit the app'**
  String get tasksPressAgainToExit;

  /// No description provided for @objectiveStatusFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All statuses'**
  String get objectiveStatusFilterAll;

  /// No description provided for @objectiveStatusFilter.
  ///
  /// In en, this message translates to:
  /// **'Filter by status'**
  String get objectiveStatusFilter;

  /// No description provided for @objectiveTimeFilter.
  ///
  /// In en, this message translates to:
  /// **'Sort by time'**
  String get objectiveTimeFilter;

  /// No description provided for @progressStatusInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get progressStatusInProgress;

  /// No description provided for @progressStatusCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get progressStatusCompleted;

  /// No description provided for @progressStatusCompletedAsStale.
  ///
  /// In en, this message translates to:
  /// **'Completed as Stale'**
  String get progressStatusCompletedAsStale;

  /// No description provided for @progressStatusNotCompleted.
  ///
  /// In en, this message translates to:
  /// **'Not Completed'**
  String get progressStatusNotCompleted;

  /// No description provided for @progressStatusClosed.
  ///
  /// In en, this message translates to:
  /// **'Closed'**
  String get progressStatusClosed;

  /// No description provided for @sortByNewest.
  ///
  /// In en, this message translates to:
  /// **'Newest'**
  String get sortByNewest;

  /// No description provided for @sortByOldest.
  ///
  /// In en, this message translates to:
  /// **'Oldest'**
  String get sortByOldest;

  /// No description provided for @tasksCardPoints.
  ///
  /// In en, this message translates to:
  /// **'{points} points'**
  String tasksCardPoints(Object points);

  /// No description provided for @tasksUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get tasksUnassigned;

  /// No description provided for @tasksDetails.
  ///
  /// In en, this message translates to:
  /// **'Task details'**
  String get tasksDetails;

  /// No description provided for @tasksDetailsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task details'**
  String get tasksDetailsEdit;

  /// No description provided for @tasksDetailsEditCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Task created by'**
  String get tasksDetailsEditCreatedBy;

  /// No description provided for @tasksDetailsEditCreatedByDeletedAccount.
  ///
  /// In en, this message translates to:
  /// **'Creator deleted their account'**
  String get tasksDetailsEditCreatedByDeletedAccount;

  /// No description provided for @tasksDetailsEditCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Task created at'**
  String get tasksDetailsEditCreatedAt;

  /// No description provided for @tasksDetailsEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited task details'**
  String get tasksDetailsEditSuccess;

  /// No description provided for @tasksDetailsEditError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble editing task details'**
  String get tasksDetailsEditError;

  /// No description provided for @tasksCloseTaskError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble closing the task'**
  String get tasksCloseTaskError;

  /// No description provided for @tasksUpdateTaskAssignmentsSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully updated task assignments'**
  String get tasksUpdateTaskAssignmentsSuccess;

  /// No description provided for @tasksUpdateTaskAssignmentsUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble updating task assignments'**
  String get tasksUpdateTaskAssignmentsUpdateError;

  /// No description provided for @tasksAddTaskAssignmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully added new task assignees'**
  String get tasksAddTaskAssignmentSuccess;

  /// No description provided for @tasksAddTaskAssignmentError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble adding new task assigee'**
  String get tasksAddTaskAssignmentError;

  /// No description provided for @tasksClosedTaskError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like this task has been closed. Updating its details and assignments is no longer possible. Please go to the Homepage and refresh your feed.'**
  String get tasksClosedTaskError;

  /// No description provided for @tasksAmendedAssigneesError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! This task\'s assignments have been updated in the meantime. Please go to the Homepage, refresh your feed and return to this task assignments.'**
  String get tasksAmendedAssigneesError;

  /// No description provided for @tasksAssigmentsCompletedStatusDueDatePassedError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like this task\'s due date has passed and **Completed** status can\'t be applied to assignments anymore. Instead, use **Completed as Stale** status.'**
  String get tasksAssigmentsCompletedStatusDueDatePassedError;

  /// No description provided for @tasksRemoveTaskAssignmentModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to remove this user from task assignments?'**
  String get tasksRemoveTaskAssignmentModalMessage;

  /// No description provided for @tasksRemoveTaskAssignmentModalCta.
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get tasksRemoveTaskAssignmentModalCta;

  /// No description provided for @tasksRemoveTaskAssignmentSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully removed task assignee'**
  String get tasksRemoveTaskAssignmentSuccess;

  /// No description provided for @tasksRemoveTaskAssignmentError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble removing the task assigee'**
  String get tasksRemoveTaskAssignmentError;

  /// No description provided for @tasksDetailsCloseTask.
  ///
  /// In en, this message translates to:
  /// **'Close task'**
  String get tasksDetailsCloseTask;

  /// No description provided for @tasksDetailsCloseTaskModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this task?\nOnce a task is closed, it will be closed for all assignees. In addition, you will no longer be able to update it.'**
  String get tasksDetailsCloseTaskModalMessage;

  /// No description provided for @tasksDetailsCloseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully closed the task'**
  String get tasksDetailsCloseSuccess;

  /// No description provided for @tasksDetailsCloseError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble closing the task'**
  String get tasksDetailsCloseError;

  /// No description provided for @tasksAssignmentsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit task assignments'**
  String get tasksAssignmentsEdit;

  /// No description provided for @tasksAssignmentsEmpty.
  ///
  /// In en, this message translates to:
  /// **'This task currently has no assigned members.\nAdd assignees below to get started.'**
  String get tasksAssignmentsEmpty;

  /// No description provided for @progressStatusLabel.
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get progressStatusLabel;

  /// No description provided for @tasksAssignmentsEditStatusSubmit.
  ///
  /// In en, this message translates to:
  /// **'Update assignments'**
  String get tasksAssignmentsEditStatusSubmit;

  /// No description provided for @tasksAssignmentsEditStatusDueDateError.
  ///
  /// In en, this message translates to:
  /// **'Cannot mark task/s as Completed since the due date has passed'**
  String get tasksAssignmentsEditStatusDueDateError;

  /// No description provided for @tasksAssignmentsEditAddNewAssignee.
  ///
  /// In en, this message translates to:
  /// **'Add additional assignees to this task:'**
  String get tasksAssignmentsEditAddNewAssignee;

  /// No description provided for @tasksAssignmentsEditAddNewAssigneeMaxedOutAssignees.
  ///
  /// In en, this message translates to:
  /// **'Maximum number of 10 assignees have been assigned to this task. Try removing some if you wish to add new ones.'**
  String get tasksAssignmentsEditAddNewAssigneeMaxedOutAssignees;

  /// No description provided for @tasksAssignmentsEditAddNewAssigneeEmptyAssignees.
  ///
  /// In en, this message translates to:
  /// **'There are no members left to assign to this task. Try adding or inviting new ones to your workspace.'**
  String get tasksAssignmentsEditAddNewAssigneeEmptyAssignees;

  /// No description provided for @tasksAssignmentsGuideMainTitle.
  ///
  /// In en, this message translates to:
  /// **'About task assignments'**
  String get tasksAssignmentsGuideMainTitle;

  /// No description provided for @tasksAssignmentsGuideAssignmentLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignments limit'**
  String get tasksAssignmentsGuideAssignmentLimitTitle;

  /// No description provided for @tasksAssignmentsGuideAssignmentLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Each task can have up to **{taskAssigneesMaxCount} assignees**.\nIf you want to remove any assignments, you can do so by clicking the **X** icon next to the assignment.\nYou can add new assignees to the current task using the form at the bottom.'**
  String tasksAssignmentsGuideAssignmentLimitBody(Object taskAssigneesMaxCount);

  /// No description provided for @tasksAssignmentsGuideAssignmentStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignments statuses'**
  String get tasksAssignmentsGuideAssignmentStatusesTitle;

  /// No description provided for @tasksAssignmentsGuideAssignmentStatusesBody.
  ///
  /// In en, this message translates to:
  /// **'__In Progress__ - the task is currently being worked on\n__Completed__ - the task was successfully completed\n__Completed as Stale__ - the task was completed after the due date has passed (applicable only if the task has a due date set)\n__Not Completed__ - the task was not completed'**
  String get tasksAssignmentsGuideAssignmentStatusesBody;

  /// No description provided for @tasksAssignmentsGuideMultipleAssigneesTitle.
  ///
  /// In en, this message translates to:
  /// **'Multiple assignees'**
  String get tasksAssignmentsGuideMultipleAssigneesTitle;

  /// No description provided for @tasksAssignmentsGuideMultipleAssigneesBody.
  ///
  /// In en, this message translates to:
  /// **'A task can be assigned to multiple members for two reasons:\n\n__Individual work__ - when you want multiple members to work on the same task independently, without needing to create duplicate tasks for each one. Each member works individually and receives the same reward points.\n\n__Team work__ - when multiple members work together on the same task as a team. Each member also receives the same reward points upon completion.\n\nIn both cases, each assigned member receives the same number of reward points set for the task.'**
  String get tasksAssignmentsGuideMultipleAssigneesBody;

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

  /// No description provided for @appDrawerWorkspaceOptions.
  ///
  /// In en, this message translates to:
  /// **'Workspace options'**
  String get appDrawerWorkspaceOptions;

  /// No description provided for @appDrawerEditWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Workspace settings'**
  String get appDrawerEditWorkspace;

  /// No description provided for @appDrawerManageUsers.
  ///
  /// In en, this message translates to:
  /// **'Workspace users'**
  String get appDrawerManageUsers;

  /// No description provided for @appDrawerNotActiveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'To see additional options, make this workspace active by clicking on its icon in the list above.'**
  String get appDrawerNotActiveWorkspace;

  /// No description provided for @appDrawerLeaveWorkspace.
  ///
  /// In en, this message translates to:
  /// **'Leave workspace'**
  String get appDrawerLeaveWorkspace;

  /// No description provided for @appDrawerLeaveWorkspaceModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to leave this workspace? **Beware: if you are the last Manager, the workspace will be entirely deleted once you leave.**'**
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

  /// No description provided for @appDrawerAbout.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get appDrawerAbout;

  /// No description provided for @appDrawerAboutSourceLicenses.
  ///
  /// In en, this message translates to:
  /// **'Source licenses'**
  String get appDrawerAboutSourceLicenses;

  /// No description provided for @appDrawerAboutVisitWebsite.
  ///
  /// In en, this message translates to:
  /// **'Visit out Website'**
  String get appDrawerAboutVisitWebsite;

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

  /// No description provided for @createNewTaskSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully created new task'**
  String get createNewTaskSuccess;

  /// No description provided for @createNewTaskError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating new task'**
  String get createNewTaskError;

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

  /// No description provided for @workspaceUsersManagementUserOptions.
  ///
  /// In en, this message translates to:
  /// **'Workspace user options'**
  String get workspaceUsersManagementUserOptions;

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
  /// **'About workspace users'**
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

  /// No description provided for @workspaceUsersManagementCreateWorkspaceInviteError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating a workspace invite link.'**
  String get workspaceUsersManagementCreateWorkspaceInviteError;

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
  /// **'Virtual users always have the Member role and it can\'t be amended.'**
  String get workspaceUsersManagementUserDetailsEditRoleBlocked;

  /// No description provided for @editDetailsSubmit.
  ///
  /// In en, this message translates to:
  /// **'Edit details'**
  String get editDetailsSubmit;

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

  /// No description provided for @createNewGoalMembersLoadError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve ran into a small hiccup loading workspace members.'**
  String get createNewGoalMembersLoadError;

  /// No description provided for @createNewGoalSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully created new goal'**
  String get createNewGoalSuccess;

  /// No description provided for @createNewGoalError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble creating new goal'**
  String get createNewGoalError;

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

  /// No description provided for @goalRequiredPointsCurrentAccumulatedPointsError.
  ///
  /// In en, this message translates to:
  /// **'Uh-uh! We\'ve had some trouble loading up this member\'s accumulated points.'**
  String get goalRequiredPointsCurrentAccumulatedPointsError;

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

  /// No description provided for @createNewGoalRequiredPointsLowerThanAccumulatedPoints.
  ///
  /// In en, this message translates to:
  /// **'Required points must be over accumulated points'**
  String get createNewGoalRequiredPointsLowerThanAccumulatedPoints;

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
  /// **'Uh-oh! The provided invite token is invalid or the workspace does not exist anymore'**
  String get workspaceCreateJoinViaInviteLinkNotFound;

  /// No description provided for @workspaceCreateJoinViaInviteLinkExpiredOrUsed.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! The provided invite token has expired or was already used'**
  String get workspaceCreateJoinViaInviteLinkExpiredOrUsed;

  /// No description provided for @workspaceCreateJoinViaInviteLinkExistingUser.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! You already are part of this workspace'**
  String get workspaceCreateJoinViaInviteLinkExistingUser;

  /// No description provided for @workspaceCreateJoinViaInviteLinkError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble adding you to the workspace'**
  String get workspaceCreateJoinViaInviteLinkError;

  /// No description provided for @workspaceCreationSuccess.
  ///
  /// In en, this message translates to:
  /// **'You\'ve successfully created new workspace'**
  String get workspaceCreationSuccess;

  /// No description provided for @leaderboardLoadRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble refreshing the leaderboard'**
  String get leaderboardLoadRefreshError;

  /// No description provided for @leaderboardSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Who’s leading the race?'**
  String get leaderboardSubtitle;

  /// No description provided for @leaderboardCompletedTasksLabel.
  ///
  /// In en, this message translates to:
  /// **'{numberOfCompletedTasks, plural, one{Completed 1 task} other{Completed {numberOfCompletedTasks} tasks}}'**
  String leaderboardCompletedTasksLabel(int numberOfCompletedTasks);

  /// No description provided for @leaderboardEmpty.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any Completed tasks yet. Try updating and completing some to get started or refreshing the feed!'**
  String get leaderboardEmpty;

  /// No description provided for @goalsLabel.
  ///
  /// In en, this message translates to:
  /// **'Goals'**
  String get goalsLabel;

  /// No description provided for @goalsLoadRefreshError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble refreshing the goals'**
  String get goalsLoadRefreshError;

  /// No description provided for @goalsNoGoals.
  ///
  /// In en, this message translates to:
  /// **'It looks like your workspace doesn\'t have any goals yet. Try creating your first one using the main **+** button below or refreshing the feed!'**
  String get goalsNoGoals;

  /// No description provided for @goalsNoFilteredGoals.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like there aren\'t any goals for the chosen filters. Try different ones!'**
  String get goalsNoFilteredGoals;

  /// No description provided for @goalsDetails.
  ///
  /// In en, this message translates to:
  /// **'Goal details'**
  String get goalsDetails;

  /// No description provided for @goalsDetailsEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit goal details'**
  String get goalsDetailsEdit;

  /// No description provided for @goalsDetailsEditCreatedBy.
  ///
  /// In en, this message translates to:
  /// **'Goal created by'**
  String get goalsDetailsEditCreatedBy;

  /// No description provided for @goalsDetailsEditCreatedByDeletedAccount.
  ///
  /// In en, this message translates to:
  /// **'Creator deleted their account'**
  String get goalsDetailsEditCreatedByDeletedAccount;

  /// No description provided for @goalsDetailsEditCreatedAt.
  ///
  /// In en, this message translates to:
  /// **'Goal created at'**
  String get goalsDetailsEditCreatedAt;

  /// No description provided for @goalsDetailsEditSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully edited goal details'**
  String get goalsDetailsEditSuccess;

  /// No description provided for @goalsDetailsEditError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble editing goal details'**
  String get goalsDetailsEditError;

  /// No description provided for @goalsCloseGoalError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble closing the goal'**
  String get goalsCloseGoalError;

  /// No description provided for @goalsDetailsCloseGoal.
  ///
  /// In en, this message translates to:
  /// **'Close goal'**
  String get goalsDetailsCloseGoal;

  /// No description provided for @goalsDetailsCloseGoalModalMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to close this goal?\nOnce a goal is closed you will no longer be able to update it.'**
  String get goalsDetailsCloseGoalModalMessage;

  /// No description provided for @goalsDetailsCloseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully closed the goal'**
  String get goalsDetailsCloseSuccess;

  /// No description provided for @goalsDetailsCloseError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble closing the goal'**
  String get goalsDetailsCloseError;

  /// No description provided for @goalsClosedGoalError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like this goal has been closed. Updating its details is no longer possible. Please go to the Goals page and refresh your feed.'**
  String get goalsClosedGoalError;

  /// No description provided for @goalsDetailsAssignedTo.
  ///
  /// In en, this message translates to:
  /// **'Goal assigned to'**
  String get goalsDetailsAssignedTo;

  /// No description provided for @goalsGuideMainTitle.
  ///
  /// In en, this message translates to:
  /// **'About goals'**
  String get goalsGuideMainTitle;

  /// No description provided for @goalsGuideBaseInfoBody.
  ///
  /// In en, this message translates to:
  /// **'Goals are flexible rewards/guidelines defined by the Manager. What a goal is is entirely up to your creativity (e.g., a gift, a day off, public recognition).'**
  String get goalsGuideBaseInfoBody;

  /// No description provided for @goalsGuideAssignmentLimitTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment limit'**
  String get goalsGuideAssignmentLimitTitle;

  /// No description provided for @goalsGuideAssignmentLimitBody.
  ///
  /// In en, this message translates to:
  /// **'Each goal can be assigned to only one member. This is because each goal is tied to reward points which the member accumulates by completing tasks, making it specific to that user.'**
  String get goalsGuideAssignmentLimitBody;

  /// No description provided for @goalsGuideStatusesTitle.
  ///
  /// In en, this message translates to:
  /// **'Assignment statuses'**
  String get goalsGuideStatusesTitle;

  /// No description provided for @goalsGuideStatusesBody.
  ///
  /// In en, this message translates to:
  /// **'__In Progress__ - the goal is currently being worked on\n__Completed__ - the goal was successfully completed'**
  String get goalsGuideStatusesBody;

  /// No description provided for @goalsGuideRequiredPointsTitle.
  ///
  /// In en, this message translates to:
  /// **'Required points'**
  String get goalsGuideRequiredPointsTitle;

  /// No description provided for @goalsGuideRequiredPointsBody.
  ///
  /// In en, this message translates to:
  /// **'Required points represent the total reward points a member needs to accumulate completing tasks to achieve a goal. Since tasks grant points in steps of 10 (10, 20, 30, 40, 50), the required points must also be a multiple of 10 (e.g. 50, 550, 5660, 25340, 30000).'**
  String get goalsGuideRequiredPointsBody;

  /// No description provided for @goalsGuideNoteTitle.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get goalsGuideNoteTitle;

  /// No description provided for @goalsGuideNoteBody.
  ///
  /// In en, this message translates to:
  /// **'If the status of a previously completed task is later changed from __Completed__ to __In Progress__, __Completed as Stale__ or __Not Completed__, or if the task is closed (__Closed__), or if the member was removed from a task as an assignee, the accumulated points are recalculated (they usually decrease). As a result, some goals that were previously completed may automatically revert to __In Progress__ until the member collects enough points again.'**
  String get goalsGuideNoteBody;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign out'**
  String get signOut;

  /// No description provided for @signOutError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble signing you out'**
  String get signOutError;

  /// No description provided for @deleteAccount.
  ///
  /// In en, this message translates to:
  /// **'Delete account'**
  String get deleteAccount;

  /// No description provided for @deleteAccountText.
  ///
  /// In en, this message translates to:
  /// **'**Things to keep in mind:**\n\nBefore deleting your account, please ensure you are not the sole Manager of any workspace you belong to. Otherwise, please consider promoting another non-virtual member to Manager.\n\nDeleting your account will remove all your memberships, task assignments, and goals across all workspaces.\n\n**Account deletion is permanent and irreversible. Do you really want to delete your account?**'**
  String get deleteAccountText;

  /// No description provided for @deleteAccountConfirmButton.
  ///
  /// In en, this message translates to:
  /// **'Yes, I understand'**
  String get deleteAccountConfirmButton;

  /// No description provided for @deleteAccountSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully deleted your account'**
  String get deleteAccountSuccess;

  /// No description provided for @deleteAccountSoleManagerConflict.
  ///
  /// In en, this message translates to:
  /// **'Account deletion is not possible because you are the sole Manager in certain workspaces you are part of. Please consider promoting another member to Manager or leave those workspaces.'**
  String get deleteAccountSoleManagerConflict;

  /// No description provided for @workspaceAccessRevocationMessage.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like you have been removed from this workspace. Please continue by pressing the button below. You will be redirected to the first available workspace.'**
  String get workspaceAccessRevocationMessage;

  /// No description provided for @workspaceRoleChangeMessage.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like your role has been changed for this workspace. Please continue by pressing the button below.'**
  String get workspaceRoleChangeMessage;

  /// No description provided for @workspaceJoinViaInviteWorkspaceInfoError.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! We\'ve had some trouble fetching workspace information'**
  String get workspaceJoinViaInviteWorkspaceInfoError;

  /// No description provided for @workspaceJoinViaInviteLinkInvalid.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! It looks like the provided invite link is invalid. Check again or contact the workspace owner for a new one.'**
  String get workspaceJoinViaInviteLinkInvalid;

  /// No description provided for @workspaceJoinViaInviteLinkExistingUser.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! You already are part of this workspace and will be redirected to it'**
  String get workspaceJoinViaInviteLinkExistingUser;

  /// No description provided for @workspaceJoinViaInviteTitle.
  ///
  /// In en, this message translates to:
  /// **'Accept Invitation'**
  String get workspaceJoinViaInviteTitle;

  /// No description provided for @workspaceJoinViaInviteText.
  ///
  /// In en, this message translates to:
  /// **'Welcome, **{invitedFirstName}**! 🎉\nWe\'re thrilled to have you.\nYou are invited to join the following workspace:'**
  String workspaceJoinViaInviteText(Object invitedFirstName);

  /// No description provided for @workspaceJoinViaInviteTextConfirm.
  ///
  /// In en, this message translates to:
  /// **'__To confirm, continue by clicking the button below__'**
  String get workspaceJoinViaInviteTextConfirm;

  /// No description provided for @notFoundPageTitle.
  ///
  /// In en, this message translates to:
  /// **'Uh-oh! Wrong turn...'**
  String get notFoundPageTitle;

  /// No description provided for @notFoundPageText.
  ///
  /// In en, this message translates to:
  /// **'Looks like you\'ve wandered off the beaten path!\nThe page you were looking for was not found.'**
  String get notFoundPageText;
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
