import '../../../../utils/command.dart';

abstract class WorkspaceInviteRepository {
  /// Reads from the cached Map of invite links per workspace ID or if there is no
  /// cache, then it fires the request.
  Future<Result<String>> createWorkspaceInviteLink(String workspaceId);
}
