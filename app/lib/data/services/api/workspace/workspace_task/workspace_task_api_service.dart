import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../paginable.dart';
import '../paginable_objectives.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/request/create_task_request.dart';
import 'models/request/update_task_details_request.dart';
import 'models/request/workspace_task_id_path_param.dart';
import 'models/response/workspace_task_response.dart';

class WorkspaceTaskApiService {
  WorkspaceTaskApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<WorkspaceTaskResponse>>> getTasks({
    required WorkspaceIdPathParam workspaceId,
    required ObjectiveRequestQueryParams queryParams,
  }) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getTasks(workspaceId),
        queryParameters: queryParams.generateQueryParamsMap(),
      );

      final apiResponse =
          ApiResponse<PaginableResponse<WorkspaceTaskResponse>>.fromJson(
            response.data,
            (json) => PaginableResponse.fromJson(
              json as Map<String, dynamic>,
              (itemJson) => WorkspaceTaskResponse.fromJson(
                itemJson as Map<String, dynamic>,
              ),
            ),
          );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<WorkspaceTaskResponse>> createTask({
    required WorkspaceIdPathParam workspaceId,
    required CreateTaskRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createTask(workspaceId),
        data: payload,
      );

      final apiResponse = ApiResponse<WorkspaceTaskResponse>.fromJson(
        response.data,
        (json) => WorkspaceTaskResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<WorkspaceTaskResponse>> updateTaskDetails({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required UpdateTaskDetailsRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        ApiEndpoints.updateTaskDetails(workspaceId, taskId),
        data: payload.toJson(),
      );

      final apiResponse = ApiResponse<WorkspaceTaskResponse>.fromJson(
        response.data,
        (json) => WorkspaceTaskResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
