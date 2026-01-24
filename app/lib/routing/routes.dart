abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';

  // Reusable subroutes
  static const createRelative = 'create';
  static const editRelative = 'edit';
  static const guideRelative = 'guide';

  // Private routes
  static const workspacesRelative = 'workspaces';

  static const workspaceCreateInitialRelative = '$createRelative/initial';
  static const workspaceCreateInitial =
      '/$workspacesRelative/$workspaceCreateInitialRelative';

  static const workspaceCreate = '/$workspacesRelative/$createRelative';

  static const workspaceJoinRelative = 'join';
  static String workspaceJoin(String inviteToken) =>
      '/$workspacesRelative/$workspaceJoinRelative/$inviteToken';

  static const workspaceUsersRelative = 'users';
  static String workspaceUsers({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$workspaceUsersRelative';
  static String workspaceUsersWithId({
    required String workspaceId,
    required String workspaceUserId,
  }) =>
      '/$workspacesRelative/$workspaceId/$workspaceUsersRelative/$workspaceUserId';
  static String workspaceUsersEditUserDetails({
    required String workspaceId,
    required String workspaceUserId,
  }) =>
      '/$workspacesRelative/$workspaceId/$workspaceUsersRelative/$workspaceUserId/$editRelative';
  static String workspaceUsersCreate({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$workspaceUsersRelative/$createRelative';
  static String workspaceUsersGuide({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$workspaceUsersRelative/$guideRelative';

  static const workspaceSettingsRelative = 'settings';
  static String workspaceSettings({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$workspaceSettingsRelative';
  static String workspaceSettingsEditWorkspaceSettings({
    required String workspaceId,
  }) =>
      '/$workspacesRelative/$workspaceId/$workspaceSettingsRelative/$editRelative';

  static const tasksRelative = 'tasks';
  static String tasks({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$tasksRelative';
  static String taskCreate({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$tasksRelative/$createRelative';
  static String taskDetails({
    required String workspaceId,
    required String taskId,
  }) => '/$workspacesRelative/$workspaceId/$tasksRelative/$taskId';
  static String taskDetailsEdit({
    required String workspaceId,
    required String taskId,
  }) =>
      '/$workspacesRelative/$workspaceId/$tasksRelative/$taskId/$editRelative';
  static const taskDetailsAssignmentsRelative = 'assignments';
  static String taskDetailsAssignmentsEdit({
    required String workspaceId,
    required String taskId,
  }) =>
      '/$workspacesRelative/$workspaceId/$tasksRelative/$taskId/$taskDetailsAssignmentsRelative/$editRelative';
  static String tasksGuide({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$tasksRelative/$guideRelative';

  static const leaderboardRelative = 'leaderboard';
  static String leaderboard({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$leaderboardRelative';

  static const goalsRelative = 'goals';
  static String goals({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$goalsRelative';
  static String goalCreate({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$goalsRelative/$createRelative';
  static String goalDetails({
    required String workspaceId,
    required String goalId,
  }) => '/$workspacesRelative/$workspaceId/$goalsRelative/$goalId';
  static String goalDetailsEdit({
    required String workspaceId,
    required String goalId,
  }) =>
      '/$workspacesRelative/$workspaceId/$goalsRelative/$goalId/$editRelative';
  static String goalsGuide({required String workspaceId}) =>
      '/$workspacesRelative/$workspaceId/$goalsRelative/$guideRelative';

  // Private global route for About app details
  static const about = '/about';

  // Private global route for setting global settings (e.g. language)
  static const preferences = '/preferences';

  static const notFound = '/not-found';
}
