import 'package:dio/dio.dart';

import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/api.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../exceptions/task_assignees_already_exist_exception.dart';
import '../../exceptions/task_assignees_count_maxed_out_exception.dart';
import '../../exceptions/task_assignees_invalid_exception.dart';
import '../../exceptions/task_closed_exception.dart';
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
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.taskClosed) {
        return const Result.error(TaskClosedException());
      }

      return Result.error(e);
    }
  }

  Future<Result<List<AddTaskAssigneeResponse>>> addTaskAssignee({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required AddTaskAssigneeRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.addTaskAssignee(workspaceId, taskId),
        data: payload.toJson(),
      );

      final apiResponse = ApiResponse<List<AddTaskAssigneeResponse>>.fromJson(
        response.data,
        (jsonList) => (jsonList as List)
            .map<AddTaskAssigneeResponse>(
              (listItem) => AddTaskAssigneeResponse.fromJson(listItem),
            )
            .toList(),
      );

      return Result.ok(apiResponse.data!);
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.taskClosed) {
        return const Result.error(TaskClosedException());
      }

      if (apiError?.code == ApiErrorCode.taskAssigneesCountMaxedOut) {
        return const Result.error(TaskAssigneesCountMaxedOutException());
      }

      if (apiError?.code == ApiErrorCode.taskAssigneesAlreadyExist) {
        return const Result.error(TaskAssigneesAlreadyExistException());
      }

      return Result.error(e);
    }
  }

  Future<Result<void>> removeTaskAssignee({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required RemoveTaskAssigneeRequest payload,
  }) async {
    try {
      await _apiClient.client.delete(
        ApiEndpoints.removeTaskAssignee(workspaceId, taskId),
        data: payload.toJson(),
      );

      return const Result.ok(null);
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.taskClosed) {
        return const Result.error(TaskClosedException());
      }

      return Result.error(e);
    }
  }

  Future<Result<List<UpdateTaskAssignmentResponse>>> updateTaskAssignments({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
    required UpdateTaskAssignmentsRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        ApiEndpoints.updateTaskAssignments(workspaceId, taskId),
        data: payload,
      );

      final apiResponse =
          ApiResponse<List<UpdateTaskAssignmentResponse>>.fromJson(
            response.data,
            (jsonList) => (jsonList as List)
                .map<UpdateTaskAssignmentResponse>(
                  (listItem) => UpdateTaskAssignmentResponse.fromJson(listItem),
                )
                .toList(),
          );

      return Result.ok(apiResponse.data!);
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.taskClosed) {
        return const Result.error(TaskClosedException());
      }

      if (apiError?.code == ApiErrorCode.taskAssigneesInvalid) {
        return const Result.error(TaskAssigneesInvalidException());
      }

      return Result.error(e);
    }
  }

  Future<Result<void>> closeTask({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceTaskIdPathParam taskId,
  }) async {
    try {
      await _apiClient.client.post(ApiEndpoints.closeTask(workspaceId, taskId));

      return const Result.ok(null);
    } on DioException catch (e) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.taskClosed) {
        return const Result.error(TaskClosedException());
      }

      return Result.error(e);
    }
  }
}
