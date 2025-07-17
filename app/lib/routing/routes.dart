abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';

  // Private routes
  static const workspacesRelative = '/workspaces';

  static const workspaceCreateInitialRelative = 'create/initial';
  static const workspaceCreateInitial =
      '$workspacesRelative/$workspaceCreateInitialRelative';

  static const workspaceCreateRelative = 'create';
  static const workspaceCreate = '$workspacesRelative/$workspaceCreateRelative';

  static const workspaceUsersRelative = 'users';
  static String workspaceUsers({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$workspaceUsersRelative';
  static const workspaceUsersCreateRelative = 'create';
  static String workspaceUsersCreate({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$workspaceUsersRelative/$workspaceUsersCreateRelative';

  static const workspaceSettingsRelative = 'settings';
  static String workspaceSettings({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$workspaceSettingsRelative';

  static const tasksRelative = 'tasks';
  static String tasks({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$tasksRelative';
  static const taskCreateRelative = 'create';
  static String taskCreate({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$tasksRelative/$taskCreateRelative';
  static String taskWithId({
    required String workspaceId,
    required String taskId,
  }) => '$workspacesRelative/$workspaceId/$tasksRelative/$taskId';

  static const leaderboardRelative = 'leaderboard';
  static String leaderboard({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$leaderboardRelative';

  static const goalsRelative = 'goals';
  static String goals({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$goalsRelative';
  static const goalCreateRelative = 'create';
  static String goalCreate({required String workspaceId}) =>
      '$workspacesRelative/$workspaceId/$goalsRelative/$goalCreateRelative';
  static String goalWithId({
    required String workspaceId,
    required String goalId,
  }) => '$workspacesRelative/$workspaceId/$goalsRelative/$goalId';

  // Private global route for setting global settings (e.g. language).
  static const preferences = '/preferences';
}
