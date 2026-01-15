import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import '../workspace_task/models/request/workspace_user_id_path_param.dart';
import 'models/request/create_virtual_workspace_user_request.dart';
import 'models/request/update_workspace_user_details_request.dart';
import 'models/response/workspace_user_accumulated_points_response.dart';
import 'models/response/workspace_user_response.dart';

class WorkspaceUserApiService extends BaseApiService {
  WorkspaceUserApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceUserResponse>>> getWorkspaceUsers(
    WorkspaceIdPathParam workspaceId,
  ) {
    return executeApiCallList(
      apiCall: () =>
          _apiClient.client.get(ApiEndpoints.getWorkspaceUsers(workspaceId)),
      fromJsonItem: WorkspaceUserResponse.fromJson,
    );
  }

  Future<Result<WorkspaceUserResponse>> createVirtualUser({
    required WorkspaceIdPathParam workspaceId,
    required CreateVirtualWorkspaceUserRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.createVirtualUser(workspaceId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceUserResponse.fromJson,
    );
  }

  Future<Result<void>> deleteWorkspaceUser({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceUserIdPathParam workspaceUserId,
  }) {
    return executeVoidApiCall(
      apiCall: () => _apiClient.client.delete(
        ApiEndpoints.deleteWorkspaceUser(workspaceId, workspaceUserId),
      ),
    );
  }

  Future<Result<WorkspaceUserResponse>> updateWorkspaceUserDetails({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceUserIdPathParam workspaceUserId,
    required UpdateWorkspaceUserDetailsRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.patch(
        ApiEndpoints.updateWorkspaceUserDetails(workspaceId, workspaceUserId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceUserResponse.fromJson,
    );
  }

  Future<Result<WorkspaceUserAccumulatedPointsResponse>>
  getWorkspaceUserAccumulatedPoints({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceUserIdPathParam workspaceUserId,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.get(
        ApiEndpoints.getWorkspaceUserAccumulatedPoints(
          workspaceId,
          workspaceUserId,
        ),
      ),
      fromJson: WorkspaceUserAccumulatedPointsResponse.fromJson,
    );
  }
}
