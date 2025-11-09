import '../data/services/api/workspace/workspace/models/request/workspace_id_path_param.dart';
import '../data/services/api/workspace/workspace_task/models/request/workspace_task_id_path_param.dart';
import '../data/services/api/workspace/workspace_task/models/request/workspace_user_id_path_param.dart';

abstract final class ApiEndpoints {
  static const _prefix = '/api';
  // Auth
  static const loginGoogle = '$_prefix/auth/google';
  static const logout = '$_prefix/auth/logout';
  static const refreshToken = '$_prefix/auth/refresh';

  // Workspaces
  static const getWorkspaces = '$_prefix/workspaces/me';
  static const createWorkspace = '$_prefix/workspaces';
  static String updateWorkspaceDetails(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId';

  // Workspace invites
  static String createWorkspaceInviteToken(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/invites';
  static String joinWorkspace(String inviteToken) =>
      '$_prefix/workspaces/invites/$inviteToken/join';

  // Tasks
  static String getTasks(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/tasks';
  static String createTask(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/tasks';
  static String updateTaskDetails(
    WorkspaceIdPathParam workspaceId,
    WorkspaceTaskIdPathParam taskId,
  ) => '$_prefix/workspaces/$workspaceId/tasks/$taskId';
  static String addTaskAssignee(
    WorkspaceIdPathParam workspaceId,
    WorkspaceTaskIdPathParam taskId,
  ) => '$_prefix/workspaces/$workspaceId/tasks/$taskId/assignments';
  static String removeTaskAssignee(
    WorkspaceIdPathParam workspaceId,
    WorkspaceTaskIdPathParam taskId,
  ) => '$_prefix/workspaces/$workspaceId/tasks/$taskId/assignments';
  static String updateTaskAssignments(
    WorkspaceIdPathParam workspaceId,
    WorkspaceTaskIdPathParam taskId,
  ) => '$_prefix/workspaces/$workspaceId/tasks/$taskId/assignments';
  static String closeTask(
    WorkspaceIdPathParam workspaceId,
    WorkspaceTaskIdPathParam taskId,
  ) => '$_prefix/workspaces/$workspaceId/tasks/$taskId/close';

  // Goals
  static String getGoals(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/goals';
  static String createGoal(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/goals';

  // Users
  static const getCurrentUser = '$_prefix/users/me';
  static String leaveWorkspace(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/users/me';
  static String getWorkspaceUsers(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/users';
  static String createVirtualUser(WorkspaceIdPathParam workspaceId) =>
      '$_prefix/workspaces/$workspaceId/users/virtual';
  static String deleteWorkspaceUser(
    WorkspaceIdPathParam workspaceId,
    WorkspaceUserIdPathParam workspaceUserId,
  ) => '$_prefix/workspaces/$workspaceId/users/$workspaceUserId';
  static String updateWorkspaceUserDetails(
    WorkspaceIdPathParam workspaceId,
    WorkspaceUserIdPathParam workspaceUserId,
  ) => '$_prefix/workspaces/$workspaceId/users/$workspaceUserId';
  static String getWorkspaceUserAccumulatedPoints(
    WorkspaceIdPathParam workspaceId,
    WorkspaceUserIdPathParam workspaceUserId,
  ) => '$_prefix/workspaces/$workspaceId/users/$workspaceUserId/points';
}
