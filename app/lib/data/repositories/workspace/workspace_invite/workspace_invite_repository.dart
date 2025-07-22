import '../../../../domain/models/workspace_invite.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceInviteRepository {
  /// Reads from the cached Map of invite token per workspace ID and if
  /// an existing token was found for the [workspaceId], checks if it expired.
  /// If not, returns that [WorkspaceInvite]. Otherwise, fetches a new one from origin.
  Future<Result<WorkspaceInvite>> createWorkspaceInviteToken({
    required String workspaceId,
    bool forceFetch = false,
  });
}
