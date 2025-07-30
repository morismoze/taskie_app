import 'package:flutter/foundation.dart';

import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceRepository extends ChangeNotifier {
  /// This is a listenable for gorouter redirect function. It's
  /// wrapped in a [ValueNotifier] because we want the gorouter
  /// refreshListenable to trigger only when this WorkspaceRepository
  /// state value changes, not on other state values changes as well.
  ValueNotifier<bool?> get hasNoWorkspacesNotifier;

  List<Workspace>? get workspaces;

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

  Future<Result<List<Workspace>>> loadWorkspaces({bool forceFetch});

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
}
