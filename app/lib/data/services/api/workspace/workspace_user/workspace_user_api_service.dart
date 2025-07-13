import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/workspace_user_response.dart';

class WorkspaceUserApiService {
  WorkspaceUserApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceUserResponse>>> getWorkspaceUsers(
    WorkspaceIdPathParam workspaceId,
  ) async {
    try {
      final response = await _apiClient.client.get(
        ApiEndpoints.getWorkspaceUsers(workspaceId),
      );

      final apiResponse = ApiResponse<List<WorkspaceUserResponse>>.fromJson(
        response.data,
        (jsonList) => (jsonList as List)
            .map<WorkspaceUserResponse>(
              (listItem) => WorkspaceUserResponse.fromJson(listItem),
            )
            .toList(),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
