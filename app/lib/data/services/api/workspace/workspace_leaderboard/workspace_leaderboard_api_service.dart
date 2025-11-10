import 'package:dio/dio.dart';

import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/api.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../exceptions/task_closed_exception.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/workspace_leaderboard_user_response.dart';

class WorkspaceLeaderboardApiService {
  WorkspaceLeaderboardApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceLeaderboardUserResponse>>> loadLeaderboard(
    WorkspaceIdPathParam workspaceId,
  ) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getLeaderboard(workspaceId),
      );

      final apiResponse =
          ApiResponse<List<WorkspaceLeaderboardUserResponse>>.fromJson(
            response.data,
            (jsonList) => (jsonList as List)
                .map<WorkspaceLeaderboardUserResponse>(
                  (listItem) =>
                      WorkspaceLeaderboardUserResponse.fromJson(listItem),
                )
                .toList(),
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
}
