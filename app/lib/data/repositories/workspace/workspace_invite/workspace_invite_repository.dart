import '../../../../domain/models/workspace.dart';
import '../../../../domain/models/workspace_invite.dart';
import '../../../../utils/command.dart';

abstract class WorkspaceInviteRepository {
  /// Reads from the in-memory cache and if an existing token was found for the [workspaceId],
  /// checks if it expired. If not, returns that [WorkspaceInvite]. Otherwise, fetches a new one from origin.
  Future<Result<WorkspaceInvite>> createWorkspaceInviteToken({
    required String workspaceId,
    bool forceFetch = false,
  });

  /// This probably brakes separation of concerns since it returns [Workspace]
  /// type which should be only returned via the `WorkspaceRepository`, so
  /// it would be better to have this method in `WorkspaceRepository` - but
  /// workspace join is under `/invites` subroute, so it also fits this repository.
  /// TODO: Will revert to this in the future.
  Future<Result<Workspace>> joinWorkspace({required String inviteToken});

  void purgeWorkspaceInvites();
}
