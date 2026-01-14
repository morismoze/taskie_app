import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import '../workspace/models/response/workspace_response.dart';
import 'models/response/create_workspace_invite_token_response.dart';

class WorkspaceInviteApiService extends BaseApiService {
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
          _apiClient.client.post(ApiEndpoints.joinWorkspace(inviteToken)),
      fromJson: WorkspaceResponse.fromJson,
    );
  }

  Future<Result<WorkspaceResponse>> fetchWorkspaceInfoByInviteToken(
    String inviteToken,
  ) async {
    return executeApiCall(
      apiCall: () => _apiClient.client.get(
        ApiEndpoints.fetchWorkspaceInfoByInviteToken(inviteToken),
      ),
      fromJson: WorkspaceResponse.fromJson,
    );
  }
}
