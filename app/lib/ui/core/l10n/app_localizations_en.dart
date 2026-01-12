// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get misc_cancel => 'Cancel';

  @override
  String get misc_tryAgain => 'Try again';

  @override
  String get misc_requiredField => 'This field is required';

  @override
  String get misc_optional => 'optional';

  @override
  String get misc_submit => 'Submit';

  @override
  String get misc_close => 'Close';

  @override
  String get misc_note => 'Note';

  @override
  String get misc_roleManager => 'Manager';

  @override
  String get misc_roleMember => 'Member';

  @override
  String get misc_ok => 'Ok';

  @override
  String get misc_comingSoon => 'Coming soon';

  @override
  String get misc_profile => 'Profile';

  @override
  String get misc_new => 'New';

  @override
  String get misc_goToHomepage => 'Go to Homepage';

  @override
  String get misc_goToGoalsPage => 'Go to Goals page';

  @override
  String get misc_pointsAbbr => 'pts';

  @override
  String get misc_errorPrompt =>
      'Uh-oh! We\'ve ran into a small hiccup loading this.';

  @override
  String get misc_retry => 'Let\'s try again';

  @override
  String get misc_somethingWentWrong => 'Uh-oh! Something went wrong';

  @override
  String get bootstrapError =>
      'Uh-oh! We\'ve had some trouble while starting up. Please try again or restart the app.';

  @override
  String get signInTitleStart => 'Organize Tasks, Achieve Goals.';

  @override
  String get signInTitleEnd => 'Successfully.';

  @override
  String get signInSubtitle =>
      'Effectively manage obligations, encourage engagement, and celebrate every success.';

  @override
  String get signInGetStarted => 'Let\'s get started';

  @override
  String get signInTitleProviders => 'Sign in method';

  @override
  String get signInViaGoogle => 'Sign in via Google';

  @override
  String get signInGoogleCanceled =>
      'Google sign-in cancelled. Please try again.';

  @override
  String get signInGoogleError =>
      'Uh-oh! We\'ve had some trouble with Google sign-in';

  @override
  String get errorOnInitialLoad =>
      'Uh-oh! We\'ve had some trouble loading up your workspace.';

  @override
  String get bottomNavigationBarTasksLabel => 'Tasks';

  @override
  String get leaderboardLabel => 'Leaderboard';

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
  String get workspaceCreateError =>
      'Uh-oh! We\'ve had some trouble creating your workspace';

  @override
  String get tasksHello => 'Hello!';

  @override
  String get tasksNoTasks =>
      'It looks like your workspace doesn\'t have any tasks yet. Try creating your first one using the main **+** button below or refreshing the feed!';

  @override
  String get tasksLoadRefreshError =>
      'Uh-oh! We\'ve had some trouble refreshing the tasks';

  @override
  String get taskskNoFilteredTasks =>
      'Uh-oh! It looks like there aren\'t any tasks for the chosen filters. Try different ones!';

  @override
  String get tasksPressAgainToExit => 'Press again to exit the app';

  @override
  String get objectiveStatusFilterAll => 'All statuses';

  @override
  String get objectiveStatusFilter => 'Filter by status';

  @override
  String get objectiveTimeFilter => 'Sort by time';

  @override
  String get progressStatusInProgress => 'In Progress';

  @override
  String get progressStatusCompleted => 'Completed';

  @override
  String get progressStatusCompletedAsStale => 'Completed as Stale';

  @override
  String get progressStatusNotCompleted => 'Not Completed';

  @override
  String get progressStatusClosed => 'Closed';

  @override
  String get sortByNewest => 'Newest';

  @override
  String get sortByOldest => 'Oldest';

  @override
  String tasksCardPoints(Object points) {
    return '$points points';
  }

  @override
  String get tasksUnassigned => 'Unassigned';

  @override
  String get tasksDetails => 'Task details';

  @override
  String get tasksDetailsEdit => 'Edit task details';

  @override
  String get tasksDetailsEditCreatedBy => 'Task created by';

  @override
  String get tasksDetailsEditCreatedByDeletedAccount =>
      'Creator deleted their account';

  @override
  String get tasksDetailsEditCreatedAt => 'Task created at';

  @override
  String get tasksDetailsEditSuccess => 'Successfully edited task details';

  @override
  String get tasksDetailsEditError =>
      'Uh-oh! We\'ve had some trouble editing task details';

  @override
  String get tasksCloseTaskError =>
      'Uh-oh! We\'ve had some trouble closing the task';

  @override
  String get tasksUpdateTaskAssignmentsSuccess =>
      'Successfully updated task assignments';

  @override
  String get tasksUpdateTaskAssignmentsUpdateError =>
      'Uh-oh! We\'ve had some trouble updating task assignments';

  @override
  String get tasksAddTaskAssignmentSuccess =>
      'Successfully added new task assignee';

  @override
  String get tasksAddTaskAssignmentError =>
      'Uh-oh! We\'ve had some trouble adding new task assigee';

  @override
  String get tasksClosedTaskError =>
      'Uh-oh! It looks like this task has been closed. Updating its details and assignments is no longer possible. Please go to the Homepage and refresh your feed.';

  @override
  String get tasksAmendedAssigneesError =>
      'Uh-oh! This task\'s assignments have been updated in the meantime. Please go to the Homepage, refresh your feed and return to this task assignments.';

  @override
  String get tasksAssigmentsCompletedStatusDueDatePassedError =>
      'Uh-oh! It looks like this task\'s due date has passed and **Completed** status can\'t be applied to assignments anymore. Instead, use **Completed as Stale** status.';

  @override
  String get tasksRemoveTaskAssignmentModalMessage =>
      'Are you sure you want to remove this user from task assignments?';

  @override
  String get tasksRemoveTaskAssignmentModalCta => 'Remove';

  @override
  String get tasksRemoveTaskAssignmentSuccess =>
      'Successfully removed task assignee';

  @override
  String get tasksRemoveTaskAssignmentError =>
      'Uh-oh! We\'ve had some trouble removing the task assigee';

  @override
  String get tasksDetailsCloseTask => 'Close task';

  @override
  String get tasksDetailsCloseTaskModalMessage =>
      'Are you sure you want to close this task?\nOnce a task is closed, it will be closed for all assignees. In addition, you will no longer be able to update it.';

  @override
  String get tasksDetailsCloseSuccess => 'Successfully closed the task';

  @override
  String get tasksDetailsCloseError =>
      'Uh-oh! We\'ve had some trouble closing the task';

  @override
  String get tasksAssignmentsEdit => 'Edit task assignments';

  @override
  String get tasksAssignmentsEmpty =>
      'This task currently has no assigned members.\nAdd assignees below to get started.';

  @override
  String get progressStatusLabel => 'Status';

  @override
  String get tasksAssignmentsEditStatusSubmit => 'Update assignments';

  @override
  String get tasksAssignmentsEditStatusDueDateError =>
      'Cannot mark task/s as Completed since the due date has passed';

  @override
  String get tasksAssignmentsEditAddNewAssignee =>
      'Add additional assignees to this task:';

  @override
  String get tasksAssignmentsEditAddNewAssigneeMaxedOutAssignees =>
      'Maximum number of 10 assignees have been assigned to this task. Try removing some if you wish to add new ones.';

  @override
  String get tasksAssignmentsEditAddNewAssigneeEmptyAssignees =>
      'There are no members left to assign to this task. Try adding or inviting new ones to your workspace.';

  @override
  String get tasksAssignmentsGuideMainTitle => 'About task assignments';

  @override
  String get tasksAssignmentsGuideAssignmentLimitTitle => 'Assignments limit';

  @override
  String tasksAssignmentsGuideAssignmentLimitBody(
    Object taskAssigneesMaxCount,
  ) {
    return 'Each task can have up to **$taskAssigneesMaxCount assignees**.\nIf you want to remove any assignments, you can do so by clicking the **X** icon next to the assignment.\nYou can add new assignees to the current task using the form at the bottom.';
  }

  @override
  String get tasksAssignmentsGuideAssignmentStatusesTitle =>
      'Assignments statuses';

  @override
  String get tasksAssignmentsGuideAssignmentStatusesBody =>
      '__In Progress__ - the task is currently being worked on\n__Completed__ - the task was successfully completed\n__Completed as Stale__ - the task was completed after the due date has passed (applicable only if the task has a due date set)\n__Not Completed__ - the task was not completed';

  @override
  String get tasksAssignmentsGuideMultipleAssigneesTitle =>
      'Multiple assignees';

  @override
  String get tasksAssignmentsGuideMultipleAssigneesBody =>
      'A task can be assigned to multiple members for two reasons:\n\n__Individual work__ - when you want multiple members to work on the same task independently, without needing to create duplicate tasks for each one. Each member works individually and receives the same reward points.\n\n__Team work__ - when multiple members work together on the same task as a team. Each member also receives the same reward points upon completion.\n\nIn both cases, each assigned member receives the same number of reward points set for the task.';

  @override
  String get appDrawerTitle => 'Workspaces';

  @override
  String get appDrawerChangeActiveWorkspaceError =>
      'Uh-oh! We\'ve had some trouble changing workspace';

  @override
  String get appDrawerWorkspaceOptions => 'Workspace options';

  @override
  String get appDrawerEditWorkspace => 'Workspace settings';

  @override
  String get appDrawerManageUsers => 'Workspace users';

  @override
  String get appDrawerNotActiveWorkspace =>
      'To see additional options, make this workspace active by clicking on its icon in the list above.';

  @override
  String get appDrawerLeaveWorkspace => 'Leave workspace';

  @override
  String get appDrawerLeaveWorkspaceModalMessage =>
      'Are you sure you want to leave this workspace? **Beware: if you are the last Manager, the workspace will be entirely deleted once you leave.**';

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
  String get preferencesLabel => 'Preferences';

  @override
  String get createNewTaskNoMembers =>
      'It looks like your workspace doesn\'t have any members to assign a task to yet. Try inviting someone or creating virtual members.';

  @override
  String get createNewTaskSuccess => 'Successfully created new task';

  @override
  String get createNewTaskError =>
      'Uh-oh! We\'ve had some trouble creating new task';

  @override
  String get objectiveNoMembersCta => 'Let\'s add members';

  @override
  String get createNewTaskTitle => 'New task';

  @override
  String get taskTitleLabel => 'Task title';

  @override
  String get taskDescriptionLabel => 'Task description';

  @override
  String get objectiveAssigneeLabel => 'Assign to';

  @override
  String get taskDueDateLabel => 'Due date';

  @override
  String get taskRewardPointsLabel => 'Reward points';

  @override
  String get objectiveTitleMinLength => 'Title must have at least 3 characters';

  @override
  String get objectiveTitleMaxLength => 'Title can have at most 50 characters';

  @override
  String get objectiveDescriptionMaxLength =>
      'Description can have at most 250 characters';

  @override
  String get taskAssigneesMinLength => 'Task must have at least 1 assignee';

  @override
  String get workspaceUsersManagement => 'Users management';

  @override
  String get workspaceUsersManagementUserOptions => 'Workspace user options';

  @override
  String get workspaceUsersManagementLoadUsersError =>
      'Uh-oh! We\'ve had some trouble loading up workspace users';

  @override
  String get workspaceUsersManagementDeleteUser => 'Remove user from workspace';

  @override
  String get workspaceUsersManagementDeleteUserModalMessage =>
      'Are you sure you want to remove this workspace user?';

  @override
  String get workspaceUsersManagementDeleteUserModalCta => 'Remove';

  @override
  String get workspaceUsersManagementDeleteUserSuccess =>
      'Successfully removed user from the workspace';

  @override
  String get workspaceUsersManagementDeleteUserError =>
      'Uh-oh! We\'ve had some trouble removing user from the workspace';

  @override
  String get workspaceUsersManagementUsersGuideMainTitle =>
      'About workspace users';

  @override
  String get workspaceUsersManagementUsersGuideIntroBody =>
      'All participants in a workspace are categorized into two main types: Team Members (who have their own app account) and Virtual Profiles (which are placeholders managed by Managers). Each user is then assigned a role that defines their permissions.';

  @override
  String get workspaceUsersManagementUsersGuideTeamMembersTitle =>
      'Team Members (Real Users)';

  @override
  String get workspaceUsersManagementUsersGuideTeamMembersBody =>
      'Team Members are users with their own account who can log in to the application. They either create a workspace (becoming a Manager automatically) or join one using an invitation link (becoming a Member automatically). The roles of Team Members can be changed by a Manager.';

  @override
  String get workspaceUsersManagementUsersGuideVirtualProfilesTitle =>
      'Virtual Profiles';

  @override
  String get workspaceUsersManagementUsersGuideVirtualProfilesBody =>
      'Virtual Profiles are placeholders for individuals who do not have an app account, such as children. They cannot log in. They can only be created by Managers and are always assigned the \'Member\' role, which cannot be changed.';

  @override
  String get workspaceUsersManagementUsersGuideRolesTitle =>
      'User Roles: Manager and Member';

  @override
  String get workspaceUsersManagementUsersGuideRolesBody =>
      'Each user in the workspace is assigned one of two roles. The user who creates a workspace automatically becomes a Manager. Users who join via an invite link are automatically assigned the Member role.';

  @override
  String get workspaceUsersManagementUsersGuideManagerRoleTitle =>
      'Manager Role';

  @override
  String get workspaceUsersManagementUsersGuideManagerRoleBody =>
      'Managers have full administrative and management control over everything in the workspace. They can invite Team Members, create Virtual Profiles, remove any user from the workspace, and change the roles of other Team Members (including promoting a Member to a Manager or demoting another Manager).';

  @override
  String get workspaceUsersManagementUsersGuideMemberRoleTitle => 'Member Role';

  @override
  String get workspaceUsersManagementUsersGuideMemberRoleBody =>
      'A Team Member with the \'Member\' role has read-only access, allowing them to view all tasks, goals, and other content, but they cannot manage them. In contrast, a Virtual Profile, which always has this role, cannot log in and serves only as a placeholder for task assignment by a Manager.';

  @override
  String get workspaceUsersManagementCreate => 'New workspace user';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteDescription =>
      'Invite new users to this workspace by sending them the invite link below:';

  @override
  String get workspaceInviteLabel => 'Workspace invite link';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteError =>
      'Uh-oh! We\'ve had some trouble creating a workspace invite link.';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteNote =>
      'Each link is single-use (send it to one user only). You can copy it to the clipboard or share it. For your convenience, after either of those two actions, a new link is generated for new usage.';

  @override
  String get workspaceUsersManagementCreateWorkspaceInviteClipboard =>
      'Successfully copied to clipboard';

  @override
  String get workspaceUsersManagementCreateVirtualUserDescription =>
      'Create a new virtual user:';

  @override
  String get workspaceUserFirstNameMinLength =>
      'First name must have at least 2 characters';

  @override
  String get workspaceUserFirstNameMaxLength =>
      'First name can have at most 50 characters';

  @override
  String get workspaceUserLastNameMinLength =>
      'Last name must have at least 2 characters';

  @override
  String get workspaceUserLastNameMaxLength =>
      'Last name can have at most 50 characters';

  @override
  String get workspaceUsersManagementCreateVirtualUserSubmit =>
      'Create new virtual user';

  @override
  String get workspaceUsersManagementCreateVirtualUserSuccess =>
      'Successfully created virtual user';

  @override
  String get workspaceUsersManagementCreateVirtualUserError =>
      'Uh-oh! We\'ve had some trouble creating virtual user';

  @override
  String get workspaceUsersManagementUserDetails => 'Workspace user details';

  @override
  String get workspaceUsersManagementUserDetailsEdit =>
      'Edit workspace user details';

  @override
  String get workspaceUsersManagementUserDetailsEditNote =>
      'Be cautious when changing a user\'s role to Manager role. Users with the Manager role have full administrative and managerial control over the workspace.';

  @override
  String get workspaceUsersManagementUserDetailsEditFirstNameBlocked =>
      'Editing first name of non-virtual users is not possible because this field is provided by the sign-up provider (e.g., Google) used for this app.';

  @override
  String get workspaceUsersManagementUserDetailsEditLastNameBlocked =>
      'Editing last name of non-virtual users is not possible because this field is provided by the sign-up provider (e.g., Google) used for this app.';

  @override
  String get workspaceUsersManagementUserDetailsEditRoleBlocked =>
      'Virtual users always have the Member role and it can\'t be amended.';

  @override
  String get editDetailsSubmit => 'Edit details';

  @override
  String get workspaceUsersManagementUserDetailsEditSuccess =>
      'Successfully edited workspace user details';

  @override
  String get workspaceUsersManagementUserDetailsEditError =>
      'Uh-oh! We\'ve had some trouble editing workspace user details';

  @override
  String get workspaceUserFirstNameLabel => 'First name';

  @override
  String get workspaceUserLastNameLabel => 'Last name';

  @override
  String get roleLabel => 'Role';

  @override
  String get workspaceUsersManagementUserDetailsCreatedBy => 'User created by';

  @override
  String get workspaceUsersManagementUserDetailsCreatedAt => 'User created at';

  @override
  String get createNewGoalNoMembers =>
      'It looks like your workspace doesn\'t have any members to assign a goal to yet. Try inviting someone or creating virtual members.';

  @override
  String get createNewGoalMembersLoadError =>
      'Uh-oh! We\'ve ran into a small hiccup loading workspace members.';

  @override
  String get createNewGoalSuccess => 'Successfully created new goal';

  @override
  String get createNewGoalError =>
      'Uh-oh! We\'ve had some trouble creating new goal';

  @override
  String get createNewGoalTitle => 'New goal';

  @override
  String get goalTitleLabel => 'Goal title';

  @override
  String get goalDescriptionLabel => 'Goal description';

  @override
  String get goalRequiredPointsCurrentAccumulatedPointsError =>
      'Uh-uh! We\'ve had some trouble loading up this member\'s accumulated points.';

  @override
  String get goalRequiredPointsCurrentAccumulatedPoints =>
      'Current accumulated points by the user';

  @override
  String get goalRequiredPointsLabel => 'Required points';

  @override
  String get createNewGoalRequiredPointsNaN =>
      'Required points must be a number without characters';

  @override
  String get createNewGoalRequiredPointsNotMultipleOf10 =>
      'Required points must be a multiple of 10';

  @override
  String get createNewGoalRequiredPointsLowerThanAccumulatedPoints =>
      'Required points must be over accumulated points';

  @override
  String get goalAssigneesRequired => 'Goal must have 1 assignee';

  @override
  String get workspaceSettings => 'Workspace settings';

  @override
  String get workspaceSettingsOwnerDeletedAccount =>
      'Owner deleted their account';

  @override
  String get workspaceSettingsCreatedBy => 'Workspace created by';

  @override
  String get workspaceSettingsCreatedAt => 'Workspace created at';

  @override
  String get workspaceSettingsEdit => 'Edit workspace details';

  @override
  String get workspaceSettingsEditSuccess =>
      'Successfully edited workspace details';

  @override
  String get workspaceSettingsEditError =>
      'Uh-oh! We\'ve had some trouble editing workspace details';

  @override
  String get preferencesLocalization => 'Localization';

  @override
  String get preferencesLocalizationLanguage => 'Language';

  @override
  String get preferencesTheme => 'Theme';

  @override
  String get preferencesThemeDarkMode => 'Dark mode';

  @override
  String get preferencesThemeDarkModeOff => 'Off';

  @override
  String get workspaceCreate => 'New workspace';

  @override
  String get workspaceCreateNewDescription => 'Create new workspace:';

  @override
  String get workspaceCreateJoinViaInviteLinkDescription =>
      'Join via workspace invite link:';

  @override
  String workspaceCreateJoinViaInviteLinkNote(Object inviteLinkExample) {
    return 'The invite link must be in the format\n$inviteLinkExample.';
  }

  @override
  String get workspaceCreateJoinViaInviteLinkSubmit => 'Join workspace';

  @override
  String get workspaceCreateJoinViaInviteLinkInvalid =>
      'Invalid invite link format';

  @override
  String get workspaceCreateJoinViaInviteLinkNotFound =>
      'Uh-oh! The provided invite token is invalid or the workspace does not exist anymore';

  @override
  String get workspaceCreateJoinViaInviteLinkExpiredOrUsed =>
      'Uh-oh! The provided invite token has expired or was already used';

  @override
  String get workspaceCreateJoinViaInviteLinkExistingUser =>
      'Uh-oh! You already are part of this workspace';

  @override
  String get workspaceCreateJoinViaInviteLinkError =>
      'Uh-oh! We\'ve had some trouble adding you to the workspace';

  @override
  String get workspaceCreationSuccess =>
      'You\'ve successfully created new workspace';

  @override
  String get leaderboardLoadRefreshError =>
      'Uh-oh! We\'ve had some trouble refreshing the leaderboard';

  @override
  String get leaderboardSubtitle => 'Who’s leading the race?';

  @override
  String leaderboardCompletedTasksLabel(int numberOfCompletedTasks) {
    String _temp0 = intl.Intl.pluralLogic(
      numberOfCompletedTasks,
      locale: localeName,
      other: 'Completed $numberOfCompletedTasks tasks',
      one: 'Completed 1 task',
    );
    return '$_temp0';
  }

  @override
  String get leaderboardEmpty =>
      'It looks like your workspace doesn\'t have any Completed tasks yet. Try updating and completing some to get started or refreshing the feed!';

  @override
  String get goalsLabel => 'Goals';

  @override
  String get goalsLoadRefreshError =>
      'Uh-oh! We\'ve had some trouble refreshing the goals';

  @override
  String get goalsNoGoals =>
      'It looks like your workspace doesn\'t have any goals yet. Try creating your first one using the main **+** button below or refreshing the feed!';

  @override
  String get goalsNoFilteredGoals =>
      'Uh-oh! It looks like there aren\'t any goals for the chosen filters. Try different ones!';

  @override
  String get goalsDetails => 'Goal details';

  @override
  String get goalsDetailsEdit => 'Edit goal details';

  @override
  String get goalsDetailsEditCreatedBy => 'Goal created by';

  @override
  String get goalsDetailsEditCreatedByDeletedAccount =>
      'Creator deleted their account';

  @override
  String get goalsDetailsEditCreatedAt => 'Goal created at';

  @override
  String get goalsDetailsEditSuccess => 'Successfully edited goal details';

  @override
  String get goalsDetailsEditError =>
      'Uh-oh! We\'ve had some trouble editing goal details';

  @override
  String get goalsCloseGoalError =>
      'Uh-oh! We\'ve had some trouble closing the goal';

  @override
  String get goalsDetailsCloseGoal => 'Close goal';

  @override
  String get goalsDetailsCloseGoalModalMessage =>
      'Are you sure you want to close this goal?\nOnce a goal is closed you will no longer be able to update it.';

  @override
  String get goalsDetailsCloseSuccess => 'Successfully closed the goal';

  @override
  String get goalsDetailsCloseError =>
      'Uh-oh! We\'ve had some trouble closing the goal';

  @override
  String get goalsClosedGoalError =>
      'Uh-oh! It looks like this goal has been closed. Updating its details is no longer possible. Please go to the Goals page and refresh your feed.';

  @override
  String get goalsDetailsAssignedTo => 'Goal assigned to';

  @override
  String get goalsGuideMainTitle => 'About goals';

  @override
  String get goalsGuideBaseInfoBody =>
      'Goals are flexible rewards/guidelines defined by the Manager. What a goal is is entirely up to your creativity (e.g., a gift, a day off, public recognition).';

  @override
  String get goalsGuideAssignmentLimitTitle => 'Assignment limit';

  @override
  String get goalsGuideAssignmentLimitBody =>
      'Each goal can be assigned to only one member. This is because each goal is tied to reward points which the member accumulates by completing tasks, making it specific to that user.';

  @override
  String get goalsGuideStatusesTitle => 'Assignment statuses';

  @override
  String get goalsGuideStatusesBody =>
      '__In Progress__ - the goal is currently being worked on\n__Completed__ - the goal was successfully completed';

  @override
  String get goalsGuideRequiredPointsTitle => 'Required points';

  @override
  String get goalsGuideRequiredPointsBody =>
      'Required points represent the total reward points a member needs to accumulate completing tasks to achieve a goal. Since tasks grant points in steps of 10 (10, 20, 30, 40, 50), the required points must also be a multiple of 10 (e.g. 50, 550, 5660, 25340, 30000).';

  @override
  String get goalsGuideNoteTitle => 'Note';

  @override
  String get goalsGuideNoteBody =>
      'If the status of a previously completed task is later changed from __Completed__ to __In Progress__, __Completed as Stale__ or __Not Completed__, or if the task is closed (__Closed__), or if the member was removed from a task as an assignee, the accumulated points are recalculated (they usually decrease). As a result, some goals that were previously completed may automatically revert to __In Progress__ until the member collects enough points again.';

  @override
  String get signOut => 'Sign out';

  @override
  String get signOutError => 'Uh-oh! We\'ve had some trouble signing you out';

  @override
  String get deleteAccount => 'Delete account';

  @override
  String get deleteAccountText =>
      '**Things to keep in mind:**\n\nBefore deleting your account, please ensure you are not the sole Manager of any workspace you belong to. Otherwise, please consider promoting another non-virtual member to Manager.\n\nDeleting your account will remove all your memberships, task assignments, and goals across all workspaces.\n\n**Account deletion is permanent and irreversible. Do you really want to delete your account?**';

  @override
  String get deleteAccountConfirmButton => 'Yes, I understand';

  @override
  String get deleteAccountSuccess => 'Successfully deleted your account';

  @override
  String get deleteAccountSoleManagerConflict =>
      'Account deletion is not possible because you are the sole Manager in certain workspaces you are part of. Please consider promoting another member to Manager or leave those workspaces.';

  @override
  String get workspaceAccessRevocationMessage =>
      'Uh-oh! It looks like you have been removed from this workspace. Please continue by pressing the button below. You will be redirected to the first available workspace.';

  @override
  String get workspaceRoleChangeMessage =>
      'Uh-oh! It looks like your role has been changed for this workspace. Please continue by pressing the button below.';

  @override
  String get workspaceJoinViaInviteWorkspaceInfoError =>
      'Uh-oh! We\'ve had some trouble fetching workspace information';

  @override
  String get workspaceJoinViaInviteLinkInvalid =>
      'Uh-oh! It looks like the provided invite link is invalid. Check again or contact the workspace owner for a new one.';

  @override
  String get workspaceJoinViaInviteLinkExistingUser =>
      'Uh-oh! You already are part of this workspace and will be redirected to it';

  @override
  String get workspaceJoinViaInviteTitle => 'Accept Invitation';

  @override
  String workspaceJoinViaInviteText(Object invitedFirstName) {
    return 'Welcome, [$invitedFirstName]! 🎉\nWe\'re thrilled to have you.\nYou are invited to join the following workspace:';
  }

  @override
  String get workspaceJoinViaInviteTextConfirm =>
      '__To confirm, continue by clicking the button below__';
}
