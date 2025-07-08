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

  // This is listenable used for redirection to workspace creation
  // screen in case user is not part of any workspace.
  @override
  bool get hasNoWorkspaces =>
      _cachedWorkspacesList == null || _cachedWorkspacesList!.isEmpty;

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
      case Error():
        _log.severe(
          'Failed to set active workspace to shared prefs',
          result.error,
        );
    }

    return result;
  }

  @override
  Future<Result<String?>> getActiveWorkspaceId() async {
    if (_activeWorkspaceId != null) {
      return Result.ok(_activeWorkspaceId);
    }

    final result = await _sharedPreferencesService.getActiveWorkspaceId();
    switch (result) {
      case Ok<String?>():
        _activeWorkspaceId = result.value;
        return Result.ok(_activeWorkspaceId);
      case Error<String?>():
        _log.severe('Failed to read active workspace ID', result.error);
        return Result.error(result.error);
    }
  }

  @override
  Future<Result<List<Workspace>>> getWorkspaces({
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

          // If user is not part of any workspace, notify the navigation redirection listener
          if (_cachedWorkspacesList!.isEmpty) {
            notifyListeners();
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
  Future<Result<void>> createWorkspace({
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

          return const Result.ok(null);
        case Error<WorkspaceResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<String>> createWorkspaceInviteLink() async {
    if (_cachedWorkspaceInviteLinks[_activeWorkspaceId] != null) {
      return Result.ok(_cachedWorkspaceInviteLinks[_activeWorkspaceId]!);
    }

    try {
      final result = await _workspaceApiService.createWorkspaceInviteLink(
        _activeWorkspaceId!,
      );

      switch (result) {
        case Ok<CreateWorkspaceInviteLinkResponse>():
          final inviteLink = result.value.inviteLink;
          _cachedWorkspaceInviteLinks[_activeWorkspaceId!] = inviteLink;
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
          if (_cachedWorkspacesList!.isNotEmpty &&
              workspaceId == _activeWorkspaceId) {
            final firstWorkspaceId = _cachedWorkspacesList!.first.id;
            setActiveWorkspaceId(firstWorkspaceId);
          }

          // If user is no more part of any workspace, notify the navigation redirection listener
          if (_cachedWorkspacesList!.isEmpty) {
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
}
