import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/create_workspace_invite_token_response.dart';

class WorkspaceInviteApiService {
  // TODO: when staging backend server is deployed, [ApiClient] needs
  // TODO: to be replaced by [ApiDeepLinkClient] - this one points to staging
  // TODO: server both on development and staging env(and to prod server on
  // TODO: production). This enables Android to do actual functionalities
  // TODO: behind opening Taslkie app behind the workspace invite URL
  // TODO: (fetching assetLinks.json from the server).
  // TODO: This ApiService should be used as well for workspace join endpoint.
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
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
