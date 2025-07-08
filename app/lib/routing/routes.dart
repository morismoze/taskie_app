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
  static const tasks = '$workspacesRelative$tasksRelative';
  static String taskWithId({required String taskId}) => '$tasks/$taskId';

  static const leaderboard = '/leaderboard';

  static const goalsRelative = '/goals';
  static const goals = '$workspacesRelative$goalsRelative';
  static String goalWithId({required String goalId}) => '$goals/$goalId';

  // Private global route for setting global settings (e.g. language).
  static const preferences = '/preferences';
}
