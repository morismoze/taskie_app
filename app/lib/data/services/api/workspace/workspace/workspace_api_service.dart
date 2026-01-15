import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import 'models/request/create_workspace_request.dart';
import 'models/request/update_workspace_details_request.dart';
import 'models/request/workspace_id_path_param.dart';
import 'models/response/workspace_response.dart';

class WorkspaceApiService extends BaseApiService {
  WorkspaceApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceResponse>>> getWorkspaces() {
    return executeApiCallList(
      apiCall: () => _apiClient.client.get(ApiEndpoints.getWorkspaces),
      fromJsonItem: WorkspaceResponse.fromJson,
    );
  }

  Future<Result<WorkspaceResponse>> createWorkspace(
    CreateWorkspaceRequest payload,
  ) async {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.createWorkspace,
        data: payload.toJson(),
      ),
      fromJson: WorkspaceResponse.fromJson,
    );
  }

  Future<Result<void>> leaveWorkspace(WorkspaceIdPathParam workspaceId) async {
    return executeVoidApiCall(
      apiCall: () =>
          _apiClient.client.delete(ApiEndpoints.leaveWorkspace(workspaceId)),
    );
  }

  Future<Result<WorkspaceResponse>> updateWorkspaceDetails({
    required WorkspaceIdPathParam workspaceId,
    required UpdateWorkspaceDetailsRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.patch(
        ApiEndpoints.updateWorkspaceDetails(workspaceId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceResponse.fromJson,
    );
  }
}
