import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';
import '../../services/api/workspace/models/request/create_workspace_request.dart';
import '../../services/api/workspace/models/response/create_workspace_invite_link_response.dart';
import '../../services/api/workspace/models/response/workspace_response.dart';
import '../../services/api/workspace/workspace_api_service.dart';
import 'workspace_repository.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl({required WorkspaceApiService workspaceApiService})
    : _workspaceApiService = workspaceApiService;

  final WorkspaceApiService _workspaceApiService;

  @override
  Future<Result<List<Workspace>>> getWorkspaces() async {
    // We don't cache workspaces, because fetching workspaces on the Entry screen
    // and them being in sync with the backend is crucial
    try {
      final result = await _workspaceApiService.getWorkspaces();
      switch (result) {
        case Ok<List<WorkspaceResponse>>():
          return Result.ok(
            result.value
                .map(
                  (workspace) => Workspace(
                    id: workspace.id,
                    name: workspace.name,
                    description: workspace.description,
                    pictureUrl: workspace.pictureUrl,
                  ),
                )
                .toList(),
          );
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
          return const Result.ok(null);
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
