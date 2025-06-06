import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';
import '../../services/api/workspace/models/response/workspace_response.dart';
import '../../services/api/workspace/workspace_api_service.dart';
import 'workspace_repository.dart';

class WorkspaceRepositoryImpl implements WorkspaceRepository {
  WorkspaceRepositoryImpl({required WorkspaceApiService workspaceApiService})
    : _workspaceApiService = workspaceApiService;

  final WorkspaceApiService _workspaceApiService;

  @override
  Future<Result<List<Workspace>>> getWorkspaces() async {
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
}
