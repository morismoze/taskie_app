import 'package:flutter/material.dart';

import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  Future<String?> get activeWorkspaceId;

  Future<void> setActiveWorkspaceId(String workspaceId);

  Future<Result<List<Workspace>>> getWorkspaces({bool forceFetch = false});

  Future<Result<Workspace>> createWorkspace({
    required String name,
    String? description,
  });

  Future<Result<String>> createWorkspaceInviteLink({
    required String workspaceId,
  });

  Future<Result<void>> leaveWorkspace({required String workspaceId});
}
