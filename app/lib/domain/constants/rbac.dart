import '../../data/services/api/user/models/response/user_response.dart';

enum RbacPermission {
  taskCreate,
  taskDelete,
  workspaceDelete,
  workspaceManageSettings,
  workspaceInviteUsers,
  workspaceRemoveUsers,
}

abstract final class RbacConfig {
  static const Map<WorkspaceRole, Set<RbacPermission>> rolePermissions = {
    WorkspaceRole.manager: {
      RbacPermission.taskCreate,
      RbacPermission.taskDelete,
      RbacPermission.workspaceDelete,
      RbacPermission.workspaceManageSettings,
      RbacPermission.workspaceInviteUsers,
      RbacPermission.workspaceRemoveUsers,
    },
    WorkspaceRole.member: {},
  };

  static bool hasPermission(WorkspaceRole role, RbacPermission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }
}
