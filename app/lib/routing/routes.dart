abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';
  static const workspacesRelative = '/workspaces';
  static const createWorkspace = '$workspacesRelative/create';

  // Private routes
  static const tasksRelative = '/tasks';
  static String taskWithId(String id) => '$tasksRelative/$id';
  static const leaderboard = '/leaderboard';
  static const goals = '/goals';
  static String goalWithId(String id) => '$goals/$id';
  static String workspaceInvite(String id) => '$workspacesRelative/$id/invite';
}
