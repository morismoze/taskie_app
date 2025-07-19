import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import '../workspace_task/models/request/workspace_user_id_path_param.dart';
import 'models/request/create_virtual_workspace_user_request.dart';
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

  Future<Result<WorkspaceUserResponse>> createVirtualUser({
    required WorkspaceIdPathParam workspaceId,
    required CreateVirtualWorkspaceUserRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createVirtualUser(workspaceId),
        data: payload,
      );

      final apiResponse = ApiResponse<WorkspaceUserResponse>.fromJson(
        response.data,
        (json) => WorkspaceUserResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> deleteWorkspaceUser({
    required WorkspaceIdPathParam workspaceId,
    required WorkspaceUserIdPathParam workspaceUserId,
  }) async {
    try {
      await _apiClient.client.delete(
        ApiEndpoints.deleteWorkspaceUser(workspaceId, workspaceUserId),
      );

      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
