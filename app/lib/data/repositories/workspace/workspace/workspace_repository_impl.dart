import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace/models/request/create_workspace_request.dart';
import '../../../services/api/workspace/workspace/models/request/update_workspace_details_request.dart';
import '../../../services/api/workspace/workspace/models/response/workspace_response.dart';
import '../../../services/api/workspace/workspace/workspace_api_service.dart';
import '../../../services/local/shared_preferences_service.dart';
import 'workspace_repository.dart';

class WorkspaceRepositoryImpl extends WorkspaceRepository {
  WorkspaceRepositoryImpl({
    required WorkspaceApiService workspaceApiService,
    required SharedPreferencesService sharedPreferencesService,
  }) : _workspaceApiService = workspaceApiService,
       _sharedPreferencesService = sharedPreferencesService;

  final WorkspaceApiService _workspaceApiService;
  final SharedPreferencesService _sharedPreferencesService;

  final _log = Logger('WorkspaceRepository');
  List<Workspace>? _cachedWorkspacesList;

  @override
  List<Workspace>? get workspaces => _cachedWorkspacesList;

  String? _activeWorkspaceId;

  @override
  String? get activeWorkspaceId => _activeWorkspaceId;

  final ValueNotifier<bool?> _hasNoWorkspacesNotifier = ValueNotifier(null);

  // This is listenable used for redirection to workspace creation
  // screen in case user is not part of any workspace.
  @override
  ValueNotifier<bool?> get hasNoWorkspacesNotifier => _hasNoWorkspacesNotifier;

  @override
  Future<Result<void>> setActiveWorkspaceId(String workspaceId) async {
    if (_activeWorkspaceId == workspaceId) {
      // Early return if the same workspaceId is already set
      return const Result.ok(null);
    }

    final result = await _sharedPreferencesService.setActiveWorkspaceId(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        _activeWorkspaceId = workspaceId;
      case Error():
        _log.severe(
          'Failed to set active workspace to shared prefs',
          result.error,
        );
    }

    return result;
  }

  @override
  Future<Result<String?>> loadActiveWorkspaceId() async {
    if (_activeWorkspaceId != null) {
      return Result.ok(_activeWorkspaceId);
    }

    final result = await _sharedPreferencesService.getActiveWorkspaceId();
    switch (result) {
      case Ok<String?>():
        _activeWorkspaceId ??= result.value;
        return Result.ok(result.value);
      case Error<String?>():
        _log.severe('Failed to read active workspace ID', result.error);
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<List<Workspace>>> loadWorkspaces({
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedWorkspacesList != null) {
      return Result.ok(_cachedWorkspacesList!);
    }

    try {
      final result = await _workspaceApiService.getWorkspaces();
      switch (result) {
        case Ok<List<WorkspaceResponse>>():
          final mappedData = result.value
              .map((workspace) => _mapWorkspaceFromResponse(workspace))
              .toList();

          _cachedWorkspacesList = mappedData;
          notifyListeners();

          // If user is not part of any workspace, notify the navigation redirection listener
          if (_cachedWorkspacesList!.isEmpty) {
            _hasNoWorkspacesNotifier.value = _cachedWorkspacesList!.isEmpty;
          }

          return Result.ok(mappedData);
        case Error<List<WorkspaceResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  }) async {
    try {
      final payload = CreateWorkspaceRequest(
        name: name,
        description: description,
      );
      final result = await _workspaceApiService.createWorkspace(payload);

      switch (result) {
        case Ok<WorkspaceResponse>():
          final newWorkspace = _mapWorkspaceFromResponse(result.value);

          // Add the new workspace to the local list (cache)
          _cachedWorkspacesList?.add(newWorkspace);
          notifyListeners();

          // We need to update [_hasNoWorkspacesNotifier] notifier, but just
          // in the case user now is part of only one workspace for 2 reasons:
          // 1. when user is not part of any workspace and creates a workspace for the first time
          // 2. we don't want to trigger this everytime user creates new workspace, because
          // we don't want the gorouter redirect function to re-trigger everytime.
          if (_cachedWorkspacesList != null &&
              _cachedWorkspacesList!.length == 1) {
            _hasNoWorkspacesNotifier.value = false;
          }

          return Result.ok(newWorkspace.id);
        case Error<WorkspaceResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> leaveWorkspace({required String workspaceId}) async {
    final leavingWorkspace = _cachedWorkspacesList?.firstWhere(
      (workspace) => workspace.id == workspaceId,
    );
    try {
      final result = await _workspaceApiService.leaveWorkspace(workspaceId);

      switch (result) {
        case Ok():
          // Remove the leaving workspace from the local list (cache)
          _cachedWorkspacesList!.remove(leavingWorkspace);
          notifyListeners();

          // If user is no more part of any workspace, notify the navigation redirection listener
          if (_cachedWorkspacesList!.isEmpty) {
            _hasNoWorkspacesNotifier.value = _cachedWorkspacesList!.isEmpty;
          }

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Result<Workspace> loadWorkspaceDetails(String workspaceId) {
    final details = _cachedWorkspacesList!.firstWhere(
      (workspace) => workspace.id == workspaceId,
    );
    return Result.ok(details);
  }

  @override
  Future<Result<void>> updateWorkspaceDetails(
    String workspaceId, {
    String? name,
    String? description,
  }) async {
    try {
      final result = await _workspaceApiService.updateWorkspaceDetails(
        workspaceId: workspaceId,
        payload: UpdateWorkspaceDetailsRequest(
          name: name,
          description: description,
        ),
      );

      switch (result) {
        case Ok():
          final updatedWorkspace = _mapWorkspaceFromResponse(result.value);

          // Update the existing workspace in the list by replacing it
          // with the new updated instance.
          final workspaceIndex = _cachedWorkspacesList!.indexWhere(
            (workspace) => workspace.id == updatedWorkspace.id,
          );

          if (workspaceIndex != -1) {
            _cachedWorkspacesList![workspaceIndex] = updatedWorkspace;
            notifyListeners();
          }

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> addWorkspace({required Workspace workspace}) async {
    if (_cachedWorkspacesList != null) {
      _cachedWorkspacesList!.add(workspace);
      notifyListeners();
      return const Result.ok(null);
    }

    return Result.error(Exception('Cached list was not initialized'));
  }

  Workspace _mapWorkspaceFromResponse(WorkspaceResponse workspace) {
    return Workspace(
      id: workspace.id,
      name: workspace.name,
      createdAt: workspace.createdAt,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
      createdBy: workspace.createdBy == null
          ? null
          : CreatedBy(
              id: workspace.createdBy!.id,
              firstName: workspace.createdBy!.firstName,
              lastName: workspace.createdBy!.lastName,
              profileImageUrl: workspace.createdBy!.profileImageUrl,
            ),
    );
  }
}
