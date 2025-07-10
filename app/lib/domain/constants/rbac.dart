import '../../data/services/api/user/models/response/user_response.dart';

enum RbacPermission {
  workspaceDelete,
  workspaceManageSettings,
  workspaceInviteUsers,
  workspaceRemoveUsers,

  /// `objective` is just a single name for either task or goal
  objectiveCreate,
}

abstract final class RbacConfig {
  static const Map<WorkspaceRole, Set<RbacPermission>> rolePermissions = {
    WorkspaceRole.manager: {
      RbacPermission.workspaceDelete,
      RbacPermission.workspaceManageSettings,
      RbacPermission.workspaceInviteUsers,
      RbacPermission.workspaceRemoveUsers,
      RbacPermission.objectiveCreate,
    },
    WorkspaceRole.member: {},
  };

  static bool hasPermission(WorkspaceRole role, RbacPermission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }
}
