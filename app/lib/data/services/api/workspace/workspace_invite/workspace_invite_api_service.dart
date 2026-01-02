import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import '../workspace/models/response/workspace_response.dart';
import 'models/response/create_workspace_invite_token_response.dart';

class WorkspaceInviteApiService extends BaseApiService {
  // TODO: when staging backend server is deployed, [ApiClient] needs
  // TODO: to be replaced by [ApiDeepLinkClient] - this one points to staging
  // TODO: server both on development and staging env(and to prod server on
  // TODO: production). This enables Android to do actual functionalities
  // TODO: behind opening the app behind the workspace invite URL
  // TODO: (fetching assetLinks.json from the server).
  // TODO: This ApiClient should be used as well for workspace join endpoint.
  WorkspaceInviteApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<CreateWorkspaceInviteTokenResponse>> createWorkspaceInviteToken(
    WorkspaceIdPathParam workspaceId,
  ) {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.createWorkspaceInviteToken(workspaceId),
      ),
      fromJson: CreateWorkspaceInviteTokenResponse.fromJson,
    );
  }

  Future<Result<WorkspaceResponse>> joinWorkspace(String inviteToken) async {
    return executeApiCall(
      apiCall: () =>
          _apiClient.client.put(ApiEndpoints.joinWorkspace(inviteToken)),
      fromJson: WorkspaceResponse.fromJson,
    );
  }
}
