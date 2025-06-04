abstract final class Routes {
  // Public routes
  static const login = '/login';

  // Private routes
  static const tasks = '/tasks';
  static String taskWithId(int id) => '$tasks/$id';
  static const leaderboard = '/leaderboard';
  static const goals = '/goals';
  static String goalWithId(int id) => '$goals/$id';
}
