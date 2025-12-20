import 'package:dio/dio.dart';

import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/api.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../exceptions/not_found_exception.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import '../workspace/models/response/workspace_response.dart';
import 'exceptions/workspace_invite_existing_user_exception.dart';
import 'exceptions/workspace_invite_expired_or_used_exception.dart';
import 'models/response/create_workspace_invite_token_response.dart';

class WorkspaceInviteApiService {
  // TODO: when staging backend server is deployed, [ApiClient] needs
  // TODO: to be replaced by [ApiDeepLinkClient] - this one points to staging
  // TODO: server both on development and staging env(and to prod server on
  // TODO: production). This enables Android to do actual functionalities
  // TODO: behind opening the app behind the workspace invite URL
  // TODO: (fetching assetLinks.json from the server).
  // TODO: This ApiClient should be used as well for workspace join endpoint.
  WorkspaceInviteApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<CreateWorkspaceInviteTokenResponse>> createWorkspaceInviteToken(
    WorkspaceIdPathParam workspaceId,
  ) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createWorkspaceInviteToken(workspaceId),
      );

      final apiResponse =
          ApiResponse<CreateWorkspaceInviteTokenResponse>.fromJson(
            response.data,
            (json) => CreateWorkspaceInviteTokenResponse.fromJson(
              json as Map<String, dynamic>,
            ),
          );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<WorkspaceResponse>> joinWorkspace(String inviteToken) async {
    try {
      final response = await _apiClient.client.put(
        ApiEndpoints.joinWorkspace(inviteToken),
      );

      final apiResponse = ApiResponse<WorkspaceResponse>.fromJson(
        response.data,
        (json) => WorkspaceResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.notFoundWorkspaceInviteToken) {
        return const Result.error(NotFoundException());
      }

      if (apiError?.code == ApiErrorCode.workspaceInviteAlreadyUsed ||
          apiError?.code == ApiErrorCode.workspaceInviteExpired) {
        return const Result.error(WorkspaceInviteExpiredOrUsedException());
      }

      if (apiError?.code == ApiErrorCode.workspaceInviteExistingUser) {
        return const Result.error(WorkspaceInviteExistingUserException());
      }

      return Result.error(e, stackTrace);
    }
  }
}
