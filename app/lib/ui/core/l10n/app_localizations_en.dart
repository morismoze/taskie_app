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
  String get misc_somethingWentWrong => 'Uh-oh! Something went wrong';

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
  String get misc_roleMember => 'ČlanMember';

  @override
  String get misc_orSeparator => 'or';

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
  String get errorOnInitialLoad =>
      'Uh-oh! We\'ve had some trouble loading up your workspace';

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
  String get workspaceCreateError =>
      'Uh-oh! We\'ve had some trouble creating your workspace';

  @override
  String get tasksHello => 'Hello!';

  @override
  String get appDrawerTitle => 'Workspaces';

  @override
  String get appDrawerChangeActiveWorkspaceError =>
      'Uh-oh! We\'ve had some trouble changing workspace';

  @override
  String get appDrawerEditWorkspace => 'Workspace setttings';

  @override
  String get appDrawerManageUsers => 'Workspace users';

  @override
  String get appDrawerNotActiveWorkspace =>
      'To see additional options, make this workspace active by clicking on its icon in the top list.';

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
  String get createNewTaskNoMembers =>
      'It looks like your workspace doesn\'t have any members to assign a task to yet. Try inviting someone or creating virtual members.';

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
      'About Workspace Users';

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
  String get workspaceUsersManagementCreateWorkspaceInviteLabel =>
      'Workspace invite link';

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
      'Virtual users always have the Member role and cannot be changed.';

  @override
  String get workspaceUsersManagementUserDetailsEditSubmit => 'Edit details';

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
  String get createNewGoalTitle => 'New goal';

  @override
  String get goalTitleLabel => 'Goal title';

  @override
  String get goalDescriptionLabel => 'Goal description';

  @override
  String get goalRequiredPointsCurrentAccumulatedPoints =>
      'Current accumulated points by the user';

  @override
  String get goalRequiredPointsLabel => 'Required points';

  @override
  String get goalRequiredPointsNote =>
      'Required points represent the total reward points a member needs to accumulate solving tasks to achieve a goal. Since tasks grant points in steps of 10 (10, 20, 30, 40, 50), the required points must also be a multiple of 10 (e.g. 50, 550, 5660, 25340, 30000).';

  @override
  String get createNewGoalRequiredPointsNaN =>
      'Required points must be a number without characters';

  @override
  String get createNewGoalRequiredPointsNotMultipleOf10 =>
      'Required points must be a multiple of 10';

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
  String get workspaceSettingsEditSubmit => 'Edit details';

  @override
  String get workspaceSettingsEditSuccess =>
      'Successfully edited workspace details';

  @override
  String get workspaceSettingsEditError =>
      'Uh-oh! We\'ve had some trouble editing workspace details';
}
