abstract final class Routes {
  static const login = '/login';
  static const tasks = '/tasks';
  static String taskWithId(int id) => '$tasks/$id';
  static const leaderboard = '/leaderboard';
  static const goals = '/goals';
  static String goalWithId(int id) => '$goals/$id';
}
