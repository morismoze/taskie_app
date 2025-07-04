abstract final class Routes {
  // Initial route
  static const entry = '/';

  // Public routes
  static const login = '/login';
  static const workspacesRelative = '/workspaces';
  static const createWorkspaceInitial = '$workspacesRelative/create/initial';

  // Private routes
  static String workspaceWithId(String id) => '$workspacesRelative/$id';
  static const tasksRelative = '/tasks';
  static String tasks({required String workspaceId}) =>
      '${workspaceWithId(workspaceId)}$tasksRelative';
  static String taskWithId({
    required String workspaceId,
    required String taskId,
  }) => '${tasks(workspaceId: workspaceId)}/$taskId';
  static const leaderboardRelative = '/leaderboard';
  static String leaderboard({required String workspaceId}) =>
      '${workspaceWithId(workspaceId)}$leaderboardRelative';
  static const goalsRelative = '/goals';
  static String goals({required String workspaceId}) =>
      '${workspaceWithId(workspaceId)}$goalsRelative';
  static String goalWithId({
    required String workspaceId,
    required String goalId,
  }) => '${goals(workspaceId: workspaceId)}$goalId';
  static String workspaceInvite(String workspaceId) =>
      '${workspaceWithId(workspaceId)}/invite';
  static const createWorkspace = '$workspacesRelative/create';
}
