abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';

  // Private routes
  static const workspacesRelative = '/workspaces';
  static const workspaceCreateInitial = '$workspacesRelative/create/initial';
  static const workspaceCreate = '$workspacesRelative/create';
  static const workspaceInvite = '$workspacesRelative/invite';
  static const workspaceSettings = '$workspacesRelative/settings';

  static const tasksRelative = '/tasks';
  static const tasksCreate = '$tasksRelative/create';
  static String taskWithId({required String taskId}) =>
      '$tasksRelative/$taskId';

  static const leaderboard = '/leaderboard';

  static const goalsRelative = '/goals';
  static const goalsCreate = '$goalsRelative/create';
  static String goalWithId({required String goalId}) =>
      '$goalsRelative/$goalId';

  // Private global route for setting global settings (e.g. language).
  static const preferences = '/preferences';
}
