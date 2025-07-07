import 'package:flutter/material.dart';

import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  bool get hasNoWorkspaces;

  /// Used when changing the current active workspace ID via the
  /// workspaces list in the app drawer.
  Future<Result<void>> setActiveWorkspaceId(String workspaceId);

  /// Used as the initial load of workspaceId and setting the local
  /// cached variable which is available via [activeWorkspaceId] getter.
  Future<Result<String?>> getActiveWorkspaceId();

  Future<Result<List<Workspace>>> getWorkspaces({bool forceFetch = false});

  Future<Result<void>> createWorkspace({
    required String name,
    String? description,
  });

  /// Reads from the cached Map of invite links per workspace ID or if there is no
  /// cache, then it fires the request. Workspace ID is read from the local
  /// active workspace ID variable.
  Future<Result<String>> createWorkspaceInviteLink();

  Future<Result<void>> leaveWorkspace({required String workspaceId});
}
