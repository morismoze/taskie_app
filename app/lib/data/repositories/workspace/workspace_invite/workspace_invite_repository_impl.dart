import 'package:logging/logging.dart';

import '../../../../domain/models/workspace_invite.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_invite/models/response/create_workspace_invite_token_response.dart';
import '../../../services/api/workspace/workspace_invite/workspace_invite_api_service.dart';
import 'workspace_invite_repository.dart';

class WorkspaceInviteRepositoryImpl implements WorkspaceInviteRepository {
  WorkspaceInviteRepositoryImpl({
    required WorkspaceInviteApiService workspaceInviteApiService,
  }) : _workspaceInviteApiService = workspaceInviteApiService;

  final WorkspaceInviteApiService _workspaceInviteApiService;

  final _log = Logger('WorkspaceInviteRepository');
  // Workspace invite per workspace ID (<workspaceId>: WorkspaceInvite)
  final Map<String, WorkspaceInvite> _cachedWorkspaceInviteTokens = {};

  @override
  Future<Result<WorkspaceInvite>> createWorkspaceInviteToken({
    required String workspaceId,
    bool forceFetch = false,
  }) async {
    if (!forceFetch &&
        _cachedWorkspaceInviteTokens[workspaceId] != null &&
        // We check if the token has expired. If it's not, it is still usable.
        // Dart will automatically convert `expiresAt` UTC to local timezone since
        // `DateTime.now()` represents current timestamp in local timezone.
        _cachedWorkspaceInviteTokens[workspaceId]!.expiresAt.isAfter(
          DateTime.now(),
        )) {
      return Result.ok(_cachedWorkspaceInviteTokens[workspaceId]!);
    }

    try {
      final result = await _workspaceInviteApiService
          .createWorkspaceInviteToken(workspaceId);

      switch (result) {
        case Ok<CreateWorkspaceInviteTokenResponse>():
          final workspaceInvite = WorkspaceInvite(
            token: result.value.token,
            expiresAt: result.value.expiresAt,
          );
          _cachedWorkspaceInviteTokens[workspaceId] = workspaceInvite;
          return Result.ok(workspaceInvite);
        case Error<CreateWorkspaceInviteTokenResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
