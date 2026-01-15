import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../../paginable.dart';
import '../paginable_objectives.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/request/add_task_assignee_request.dart';
import 'models/request/create_task_request.dart';
import 'models/request/remove_task_assignee_request.dart';
import 'models/request/update_task_assignments_request.dart';
import 'models/request/update_task_details_request.dart';
import 'models/request/workspace_task_id_path_param.dart';
import 'models/response/add_task_assignee_response.dart';
import 'models/response/update_task_assignment_response.dart';
import 'models/response/workspace_task_response.dart';

class WorkspaceTaskApiService extends BaseApiService {
  WorkspaceTaskApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<WorkspaceTaskResponse>>> getTasks({
    required WorkspaceIdPathParam workspaceId,
    required ObjectiveRequestQueryParams queryParams,
  }) {
    return executeApiCallPaginable(
      apiCall: () => _apiClient.client.get(
        ApiEndpoints.getTasks(workspaceId),
        queryParameters: queryParams.generateQueryParamsMap(),
      ),
      fromJsonItem: WorkspaceTaskResponse.fromJson,
    );
  }

  Future<Result<WorkspaceTaskResponse>> createTask({
    required WorkspaceIdPathParam workspaceId,
    required CreateTaskRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.createTask(workspaceId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceTaskResponse.fromJson,
    );
  }

  Future<Result<WorkspaceTaskResponse>> updateTaskDetails({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required UpdateTaskDetailsRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.patch(
        ApiEndpoints.updateTaskDetails(workspaceId, taskId),
        data: payload.toJson(),
      ),
      fromJson: WorkspaceTaskResponse.fromJson,
    );
  }

  Future<Result<List<AddTaskAssigneeResponse>>> addTaskAssignee({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required AddTaskAssigneeRequest payload,
  }) {
    return executeApiCallList(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.addTaskAssignee(workspaceId, taskId),
        data: payload.toJson(),
      ),
      fromJsonItem: AddTaskAssigneeResponse.fromJson,
    );
  }

  Future<Result<void>> removeTaskAssignee({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required RemoveTaskAssigneeRequest payload,
  }) {
    return executeVoidApiCall(
      apiCall: () => _apiClient.client.delete(
        ApiEndpoints.removeTaskAssignee(workspaceId, taskId),
        data: payload.toJson(),
      ),
    );
  }

  Future<Result<List<UpdateTaskAssignmentResponse>>> updateTaskAssignments({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required UpdateTaskAssignmentsRequest payload,
  }) {
    return executeApiCallList(
      apiCall: () => _apiClient.client.patch(
        ApiEndpoints.updateTaskAssignments(workspaceId, taskId),
        data: payload.toJson(),
      ),
      fromJsonItem: UpdateTaskAssignmentResponse.fromJson,
    );
  }

  Future<Result<void>> closeTask({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
  }) {
    return executeVoidApiCall(
      apiCall: () =>
          _apiClient.client.patch(ApiEndpoints.closeTask(workspaceId, taskId)),
    );
  }
}
