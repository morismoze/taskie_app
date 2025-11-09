import '../../data/services/api/user/models/response/user_response.dart';

enum RbacPermission {
  workspaceDelete,
  workspaceSettingsManage,
  workspaceUsersCreate,
  workspaceUsersEditDetails,
  workspaceUsersRemove,
  // `objective` is just a single name for either task or goal
  objectiveCreate,
  objectiveEdit,
}

abstract final class RbacConfig {
  static const Map<WorkspaceRole, Set<RbacPermission>> rolePermissions = {
    WorkspaceRole.manager: {
      RbacPermission.workspaceDelete,
      RbacPermission.workspaceSettingsManage,
      RbacPermission.workspaceUsersCreate,
      RbacPermission.workspaceUsersEditDetails,
      RbacPermission.workspaceUsersRemove,
      RbacPermission.objectiveCreate,
      RbacPermission.objectiveEdit,
    },
    WorkspaceRole.member: {},
  };

  static bool hasPermission(WorkspaceRole role, RbacPermission permission) {
    return rolePermissions[role]?.contains(permission) ?? false;
  }
}
