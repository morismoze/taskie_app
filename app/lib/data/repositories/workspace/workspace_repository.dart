import 'package:flutter/foundation.dart';

import '../../../domain/models/workspace.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  bool? get hasNoWorkspaces;

  /// Reads either from local cache or from storage. When read from storage,
  /// it also sets the local cache.
  Future<Result<String?>> getActiveWorkspaceId();

  /// This method is invoked only in the gorouter inside the `/workspaces/:id` route redirect.
  Future<Result<void>> setActiveWorkspaceId(String workspaceId);

  Future<Result<List<Workspace>>> getWorkspaces({bool forceFetch});

  /// Returns `workspaceId` of the newly created workspace.
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  });

  /// Reads from the cached Map of invite links per workspace ID or if there is no
  /// cache, then it fires the request. Workspace ID is read from the local
  /// active workspace ID variable.
  Future<Result<String>> createWorkspaceInviteLink(String workspaceId);

  Future<Result<void>> leaveWorkspace({required String workspaceId});

  Future<Result<List<WorkspaceUser>>> getWorkspaceUsers({
    required String workspaceId,
    bool forceFetch,
  });
}
