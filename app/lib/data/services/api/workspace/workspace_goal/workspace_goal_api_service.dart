import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../../paginable.dart';
import '../paginable_objectives.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/request/create_goal_request.dart';
import 'models/request/update_goal_details_request.dart';
import 'models/request/workspace_goal_id_path_param.dart';
import 'models/response/workspace_goal_response.dart';

class WorkspaceGoalApiService extends BaseApiService {
  WorkspaceGoalApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<WorkspaceGoalResponse>>> getGoals({
    required WorkspaceIdPathParam workspaceId,
    required ObjectiveRequestQueryParams queryParams,
  }) {
    return executeApiCallPaginable(
      apiCall: () => _apiClient.client.get(
        ApiEndpoints.getGoals(workspaceId),
        queryParameters: queryParams.generateQueryParamsMap(),
      ),
      fromJsonItem: WorkspaceGoalResponse.fromJson,
    );
  }

  Future<Result<WorkspaceGoalResponse>> createGoal({
    required WorkspaceIdPathParam workspaceId,
    required CreateGoalRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.createGoal(workspaceId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceGoalResponse.fromJson,
    );
  }

  Future<Result<WorkspaceGoalResponse>> updateGoalDetails({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceGoalIdPathParam goalId,
    required UpdateGoalDetailsRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.patch(
        ApiEndpoints.updateGoalDetails(workspaceId, goalId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceGoalResponse.fromJson,
    );
  }

  Future<Result<void>> closeGoal({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceGoalIdPathParam goalId,
  }) {
    return executeVoidApiCall(
      apiCall: () =>
          _apiClient.client.post(ApiEndpoints.closeGoal(workspaceId, goalId)),
    );
  }
}
