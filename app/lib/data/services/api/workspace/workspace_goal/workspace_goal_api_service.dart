import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../../paginable.dart';
import '../paginable_objectives.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/workspace_goal_response.dart';

class WorkspaceGoalApiService {
  WorkspaceGoalApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<WorkspaceGoalResponse>>> getGoals({
    required WorkspaceIdPathParam workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
  }) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getGoals(workspaceId),
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
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
