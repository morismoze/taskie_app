import 'package:logging/logging.dart';

import '../../../../domain/models/workspace_invite.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_invite/models/response/create_workspace_invite_link_response.dart';
import '../../../services/api/workspace/workspace_invite/workspace_invite_api_service.dart';
import 'workspace_invite_repository.dart';

class WorkspaceInviteRepositoryImpl implements WorkspaceInviteRepository {
  WorkspaceInviteRepositoryImpl({
    required WorkspaceInviteApiService workspaceInviteApiService,
  }) : _workspaceInviteApiService = workspaceInviteApiService;

  final WorkspaceInviteApiService _workspaceInviteApiService;

  final _log = Logger('WorkspaceInviteRepository');
  // Invite link per workspace ID (<workspaceId>: WorkspaceInvite)
  final Map<String, WorkspaceInvite> _cachedWorkspaceInviteLinks = {};

  @override
  Future<Result<WorkspaceInvite>> createWorkspaceInviteLink(
    String workspaceId,
  ) async {
    if (_cachedWorkspaceInviteLinks[workspaceId] != null &&
        // We check if the link has expired. If it's not, it is still usable.
        // Dart will automatically convert `expiresAt` UTC to local timezone since
        // `DateTime.now()` represents current timestamp in local timezone.
        _cachedWorkspaceInviteLinks[workspaceId]!.expiresAt.isAfter(
          DateTime.now(),
        )) {
      return Result.ok(_cachedWorkspaceInviteLinks[workspaceId]!);
    }

    try {
      final result = await _workspaceInviteApiService.createWorkspaceInviteLink(
        workspaceId,
      );

      switch (result) {
        case Ok<CreateWorkspaceInviteLinkResponse>():
          final workspaceInvite = WorkspaceInvite(
            inviteLink: result.value.inviteLink,
            expiresAt: result.value.expiresAt,
          );
          _cachedWorkspaceInviteLinks[workspaceId] = workspaceInvite;
          return Result.ok(workspaceInvite);
        case Error<CreateWorkspaceInviteLinkResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
