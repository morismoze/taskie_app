abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';
  static const createWorkspace = '/create-workspace';

  // Private routes
  static const tasks = '/tasks';
  static String taskWithId(int id) => '$tasks/$id';
  static const leaderboard = '/leaderboard';
  static const goals = '/goals';
  static String goalWithId(int id) => '$goals/$id';
}
