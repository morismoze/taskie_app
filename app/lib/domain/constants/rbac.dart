import '../../data/services/api/user/models/response/user_response.dart';

enum RbacPermission {
  createTask,
  deleteTask,
  deleteWorkspace,
  manageWorkspaceSettings,
  inviteWorkspaceUsers,
  removeWorkspaceUsers,
}

abstract final class RbacConfig {
  static const Map<WorkspaceRole, Set<RbacPermission>> rolePermissions = {
    WorkspaceRole.manager: {
      RbacPermission.createTask,
      RbacPermission.deleteTask,
      RbacPermission.deleteWorkspace,
      RbacPermission.manageWorkspaceSettings,
      RbacPermission.inviteWorkspaceUsers,
      RbacPermission.removeWorkspaceUsers,
    },
    WorkspaceRole.member: {},
  };

  static bool hasPermission(WorkspaceRole role, RbacPermission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }
}
