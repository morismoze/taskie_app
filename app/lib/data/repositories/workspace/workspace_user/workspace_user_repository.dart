import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceUserRepository {
  Future<Result<List<WorkspaceUser>>> getWorkspaceUsers({
    required String workspaceId,
    bool forceFetch,
  });
}
