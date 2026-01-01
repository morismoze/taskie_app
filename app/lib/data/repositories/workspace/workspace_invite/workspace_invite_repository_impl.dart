import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../domain/models/workspace_invite.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace/models/response/workspace_response.dart';
import '../../../services/api/workspace/workspace_invite/models/response/create_workspace_invite_token_response.dart';
import '../../../services/api/workspace/workspace_invite/workspace_invite_api_service.dart';
import '../../../services/local/logger_service.dart';
import 'workspace_invite_repository.dart';

class WorkspaceInviteRepositoryImpl implements WorkspaceInviteRepository {
  WorkspaceInviteRepositoryImpl({
    required WorkspaceInviteApiService workspaceInviteApiService,
    required LoggerService loggerService,
  }) : _workspaceInviteApiService = workspaceInviteApiService,
       _loggerService = loggerService;

  final WorkspaceInviteApiService _workspaceInviteApiService;
  final LoggerService _loggerService;

  // Workspace invite per workspace ID (<workspaceId>: WorkspaceInvite)
  final Map<String, WorkspaceInvite> _cachedWorkspaceInviteTokens = {};

  @override
  Future<Result<WorkspaceInvite>> createWorkspaceInviteToken({
    required String workspaceId,
    bool forceFetch = false,
  }) async {
    // Read from in-memory cache
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

    // Trigger API request
    final result = await _workspaceInviteApiService.createWorkspaceInviteToken(
      workspaceId,
    );
    switch (result) {
      case Ok<CreateWorkspaceInviteTokenResponse>():
        final workspaceInvite = WorkspaceInvite(
          token: result.value.token,
          expiresAt: result.value.expiresAt,
        );
        _cachedWorkspaceInviteTokens[workspaceId] = workspaceInvite;
        return Result.ok(workspaceInvite);
      case Error<CreateWorkspaceInviteTokenResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceInviteApiService.createWorkspaceInviteToken failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<Workspace>> joinWorkspace({required String inviteToken}) async {
    final result = await _workspaceInviteApiService.joinWorkspace(inviteToken);

    switch (result) {
      case Ok<WorkspaceResponse>():
        final workspace = result.value;
        final joinedWorkspace = Workspace(
          id: workspace.id,
          name: workspace.name,
          createdAt: workspace.createdAt,
          description: workspace.description,
          pictureUrl: workspace.pictureUrl,
          createdBy: workspace.createdBy == null
              ? null
              : CreatedBy(
                  id: workspace.createdBy!.id,
                  firstName: workspace.createdBy!.firstName,
                  lastName: workspace.createdBy!.lastName,
                  profileImageUrl: workspace.createdBy!.profileImageUrl,
                ),
        );
        return Result.ok(joinedWorkspace);
      case Error<WorkspaceResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceInviteApiService.joinWorkspace failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  void purgeWorkspaceInvites() {
    _cachedWorkspaceInviteTokens.clear();
  }
}
