import 'package:flutter/foundation.dart';

import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  bool? get hasNoWorkspaces;

  /// This is used for Rbac widget, so it doesn't need to use
  /// async [loadActiveWorkspaceId] - that method is called once
  /// on app startup on the EntryScreen.
  String? get activeWorkspaceId;

  /// This method is invoked on the EntryScreen or when user either leaves a
  /// workspace, joins one or creates one (ActiveWorkspaceChangeUseCase).
  Future<Result<void>> setActiveWorkspaceId(String workspaceId);

  /// Reads either from local cache or from storage. When read from storage,
  /// it also sets the local cache. This is used only in one place - on app
  /// startup or to be precise, in EntryScreenViewmodel.
  Future<Result<String?>> loadActiveWorkspaceId();

  Result<Workspace> getActiveWorkspaceDetails();

  Future<Result<List<Workspace>>> loadWorkspaces({bool forceFetch});

  /// Returns `workspaceId` of the newly created workspace.
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  });

  Future<Result<void>> leaveWorkspace({required String workspaceId});
}
