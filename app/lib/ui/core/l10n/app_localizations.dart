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
  /// **'Edit workspace setttings'**
  String get appDrawerEditWorkspace;

  /// No description provided for @appDrawerManageUsers.
  ///
  /// In en, this message translates to:
  /// **'Manage users'**
  String get appDrawerManageUsers;

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
