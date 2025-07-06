import 'package:logging/logging.dart';

import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';
import '../../services/api/workspace/models/request/create_workspace_request.dart';
import '../../services/api/workspace/models/response/create_workspace_invite_link_response.dart';
import '../../services/api/workspace/models/response/workspace_response.dart';
import '../../services/api/workspace/workspace_api_service.dart';
import '../../services/local/shared_preferences_service.dart';
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
  String? _activeWorkspaceId;
  List<Workspace>? _cachedWorkspacesList;
  // Invite links per workspace IDs (workspaceId: inviteLink)
  final Map<String, String> _cachedWorkspaceInviteLinks = {};

  @override
  Future<Result<void>> setActiveWorkspaceId(String workspaceId) async {
    if (_activeWorkspaceId != null && _activeWorkspaceId == workspaceId) {
      // Early return if the same workspaceId is already set
      return const Result.ok(null);
    }

    final result = await _sharedPreferencesService.setActiveWorkspaceId(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        _activeWorkspaceId = workspaceId;
        notifyListeners();
      case Error():
        _log.severe(
          'Failed to set active workspace to shared prefs',
          result.error,
        );
    }

    return result;
  }

  @override
  Future<String?> get activeWorkspaceId async {
    if (_activeWorkspaceId != null) {
      return _activeWorkspaceId!;
    }

    final result = await _sharedPreferencesService.getActiveWorkspaceId();

    switch (result) {
      case Ok<String?>():
        _activeWorkspaceId = result.value;
        notifyListeners();
        return _activeWorkspaceId;
      case Error<String?>():
        _log.severe(
          'Failed to read active workspace ID from shared prefs',
          result.error,
        );
        return null;
    }
  }

  @override
  bool get hasNoWorkspaces =>
      _cachedWorkspacesList == null || _cachedWorkspacesList!.isEmpty;

  @override
  Future<Result<List<Workspace>>> getWorkspaces({
    bool forceFetch = false,
  }) async {
    if (_cachedWorkspacesList != null && !forceFetch) {
      return Result.ok(_cachedWorkspacesList!);
    }

    try {
      final result = await _workspaceApiService.getWorkspaces();
      switch (result) {
        case Ok<List<WorkspaceResponse>>():
          final mappedData = result.value
              .map(
                (workspace) => Workspace(
                  id: workspace.id,
                  name: workspace.name,
                  description: workspace.description,
                  pictureUrl: workspace.pictureUrl,
                ),
              )
              .toList();
          _cachedWorkspacesList = mappedData;

          if (await activeWorkspaceId == null && mappedData.isNotEmpty) {
            final firstWorkspaceId = mappedData.first.id;
            setActiveWorkspaceId(firstWorkspaceId);
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
  Future<Result<Workspace>> createWorkspace({
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
          final workspace = result.value;
          final newWorkspace = Workspace(
            id: workspace.id,
            name: workspace.name,
            description: workspace.description,
            pictureUrl: workspace.pictureUrl,
          );

          // Add the new workspace to the local list (cache)
          _cachedWorkspacesList?.add(newWorkspace);
          // Set new workspace as active one
          setActiveWorkspaceId(newWorkspace.id);

          return Result.ok(newWorkspace);
        case Error<WorkspaceResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> createWorkspaceInviteLink({
    required String workspaceId,
  }) async {
    if (_cachedWorkspaceInviteLinks[workspaceId] != null) {
      return Result.ok(_cachedWorkspaceInviteLinks[workspaceId]!);
    }

    try {
      final result = await _workspaceApiService.createWorkspaceInviteLink(
        workspaceId,
      );

      switch (result) {
        case Ok<CreateWorkspaceInviteLinkResponse>():
          final inviteLink = result.value.inviteLink;
          _cachedWorkspaceInviteLinks[workspaceId] = inviteLink;
          return Result.ok(inviteLink);
        case Error<CreateWorkspaceInviteLinkResponse>():
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
          // Set a first workspace from the cached list as active one only if
          // the leaving workspace was the current active one
          if (_cachedWorkspacesList != null &&
              _cachedWorkspacesList!.isNotEmpty &&
              workspaceId == _activeWorkspaceId) {
            final firstWorkspaceId = _cachedWorkspacesList!.first.id;
            setActiveWorkspaceId(firstWorkspaceId);
          }

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
