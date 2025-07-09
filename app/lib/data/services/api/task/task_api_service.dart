import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../api_response.dart';
import '../paginable.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/task_response.dart';

class TaskApiService {
  TaskApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<PaginableResponse<TaskResponse>>> getTasks({
    required WorkspaceIdPathParam workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
  }) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getTasks(workspaceId),
      );

      final apiResponse = ApiResponse<PaginableResponse<TaskResponse>>.fromJson(
        response.data,
        (json) => PaginableResponse.fromJson(
          json as Map<String, dynamic>,
          (itemJson) => TaskResponse.fromJson(itemJson as Map<String, dynamic>),
        ),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
