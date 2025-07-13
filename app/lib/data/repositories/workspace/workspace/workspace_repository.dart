import 'package:flutter/foundation.dart';

import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';

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

  Future<Result<void>> leaveWorkspace({required String workspaceId});
}
