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
  List<Workspace>? _cachedData;
  String? _activeWorkspaceId;

  @override
  Future<void> setActiveWorkspaceId(String workspaceId) async {
    await _sharedPreferencesService.setActiveWorkspaceId(
      workspaceId: workspaceId,
    );
    _activeWorkspaceId = workspaceId;
    notifyListeners();
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
  Future<Result<List<Workspace>>> getWorkspaces({
    bool forceFetch = false,
  }) async {
    if (_cachedData != null && !forceFetch) {
      return Result.ok(_cachedData!);
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
          _cachedData = mappedData;

          if (_activeWorkspaceId == null && mappedData.isNotEmpty) {
            final firstWorkspaceId = mappedData[0].id;
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
          final mappedData = Workspace(
            id: workspace.id,
            name: workspace.name,
            description: workspace.description,
            pictureUrl: workspace.pictureUrl,
          );

          setActiveWorkspaceId(mappedData.id);

          return Result.ok(mappedData);
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
    try {
      final result = await _workspaceApiService.createWorkspaceInviteLink(
        workspaceId,
      );

      switch (result) {
        case Ok<CreateWorkspaceInviteLinkResponse>():
          return Result.ok(result.value.inviteLink);
        case Error<CreateWorkspaceInviteLinkResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> leaveWorkspace({required String workspaceId}) async {
    try {
      final result = await _workspaceApiService.leaveWorkspace(workspaceId);

      switch (result) {
        case Ok():
          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
