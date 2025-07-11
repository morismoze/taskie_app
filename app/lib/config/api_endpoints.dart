import '../data/services/api/workspace/models/request/workspace_id_path_param.dart';

abstract final class ApiEndpoints {
  static const _prefix = '/api';
  // Auth
  static const loginGoogle = '$_prefix/auth/google';
  static const logout = '$_prefix/auth/logout';
  static const refreshToken = '$_prefix/auth/refresh';

  // Users
  static const getCurrentUser = '$_prefix/users/me';

  // Workspaces
  static const getWorkspaces = '$_prefix/workspaces/me';
  static const createWorkspace = '$_prefix/workspaces';
  static String createWorkspaceInviteLink(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/invites';
  static String leaveWorkspace(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/members';
  static String getTasks(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/tasks';
  static String getGoals(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/goals';
  static String getWorkspaceUsers(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/members';
}
