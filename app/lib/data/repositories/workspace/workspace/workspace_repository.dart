import 'package:flutter/foundation.dart';

import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  /// This is a listenable for gorouter redirect function.
  ValueNotifier<bool?> get hasNoWorkspacesNotifier;

  List<Workspace>? get workspaces;

  /// ID of the currently active workspace.
  String? get activeWorkspaceId;

  Future<Result<void>> setActiveWorkspaceId(String? workspaceId);

  /// Reads either from local cache or from storage. When read from storage,
  /// it also sets the local cache.
  Future<Result<String?>> loadActiveWorkspaceId();

  Stream<Result<List<Workspace>>> loadWorkspaces({bool forceFetch});

  /// Returns `workspaceId` of the newly created workspace.
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  });

  Future<Result<void>> leaveWorkspace({required String workspaceId});

  Result<Workspace> loadWorkspaceDetails(String workspaceId);

  Future<Result<void>> updateWorkspaceDetails(
    String workspaceId, {
    String? name,
    String? description,
  });

  /// This method is used in conjuction with `WorkspaceInviteRepository`'s
  /// `joinWorkspace` method.
  Future<Result<void>> addWorkspace({required Workspace workspace});

  Future<void> purgeWorkspacesCache();
}
