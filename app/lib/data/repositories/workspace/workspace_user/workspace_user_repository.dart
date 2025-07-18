import 'package:flutter/material.dart';

import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceUserRepository extends ChangeNotifier {
  List<WorkspaceUser>? get users;

  Future<Result<List<WorkspaceUser>>> loadWorkspaceUsers({
    required String workspaceId,
    bool forceFetch,
  });

  Future<Result<WorkspaceUser>> createVirtualMember({
    required String workspaceId,
    required String firstName,
    required String lastName,
  });

  Result<WorkspaceUser> loadWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
  });
}
