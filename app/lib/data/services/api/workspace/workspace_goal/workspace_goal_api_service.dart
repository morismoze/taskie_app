import 'package:dio/dio.dart';

import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/api.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../exceptions/goal_closed_exception.dart';
import '../../paginable.dart';
import '../paginable_objectives.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/request/create_goal_request.dart';
import 'models/request/update_goal_details_request.dart';
import 'models/request/workspace_goal_id_path_param.dart';
import 'models/response/workspace_goal_response.dart';

class WorkspaceGoalApiService {
  WorkspaceGoalApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<WorkspaceGoalResponse>>> getGoals({
    required WorkspaceIdPathParam workspaceId,
    required ObjectiveRequestQueryParams queryParams,
  }) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getGoals(workspaceId),
        queryParameters: queryParams.generateQueryParamsMap(),
      );

      final apiResponse =
          ApiResponse<PaginableResponse<WorkspaceGoalResponse>>.fromJson(
            response.data,
            (json) => PaginableResponse.fromJson(
              json as Map<String, dynamic>,
              (itemJson) => WorkspaceGoalResponse.fromJson(
                itemJson as Map<String, dynamic>,
              ),
            ),
          );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<WorkspaceGoalResponse>> createGoal({
    required WorkspaceIdPathParam workspaceId,
    required CreateGoalRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createGoal(workspaceId),
        data: payload,
      );

      final apiResponse = ApiResponse<WorkspaceGoalResponse>.fromJson(
        response.data,
        (json) => WorkspaceGoalResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<WorkspaceGoalResponse>> updateGoalDetails({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceGoalIdPathParam goalId,
    required UpdateGoalDetailsRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        ApiEndpoints.updateGoalDetails(workspaceId, goalId),
        data: payload.toJson(),
      );

      final apiResponse = ApiResponse<WorkspaceGoalResponse>.fromJson(
        response.data,
        (json) => WorkspaceGoalResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.goalClosed) {
        return const Result.error(GoalClosedException());
      }

      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> closeGoal({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceGoalIdPathParam goalId,
  }) async {
    try {
      await _apiClient.client.post(ApiEndpoints.closeGoal(workspaceId, goalId));

      return const Result.ok(null);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError?.code == ApiErrorCode.goalClosed) {
        return const Result.error(GoalClosedException());
      }

      return Result.error(e, stackTrace);
    }
  }
}
