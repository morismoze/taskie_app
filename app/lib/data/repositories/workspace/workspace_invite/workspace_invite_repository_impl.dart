import 'package:logging/logging.dart';

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
  // Invite links per workspace IDs (workspaceId: inviteLink)
  final Map<String, String> _cachedWorkspaceInviteLinks = {};

  @override
  Future<Result<String>> createWorkspaceInviteLink(String workspaceId) async {
    // TODO: when backend endpoint is updated by responding with expiresAt as well, expiresAt needs to be checked as well
    if (_cachedWorkspaceInviteLinks[workspaceId] != null) {
      return Result.ok(_cachedWorkspaceInviteLinks[workspaceId]!);
    }

    try {
      final result = await _workspaceInviteApiService.createWorkspaceInviteLink(
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
}
