import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import 'models/request/create_workspace_request.dart';
import 'models/request/update_workspace_details_request.dart';
import 'models/request/workspace_id_path_param.dart';
import 'models/response/workspace_response.dart';

class WorkspaceApiService {
  WorkspaceApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceResponse>>> getWorkspaces() async {
    try {
      final response = await _apiClient.client.get(ApiEndpoints.getWorkspaces);

      final apiResponse = ApiResponse<List<WorkspaceResponse>>.fromJson(
        response.data,
        (jsonList) => (jsonList as List)
            .map<WorkspaceResponse>(
              (listItem) => WorkspaceResponse.fromJson(listItem),
            )
            .toList(),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<WorkspaceResponse>> createWorkspace(
    CreateWorkspaceRequest payload,
  ) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createWorkspace,
        data: payload,
      );

      final apiResponse = ApiResponse<WorkspaceResponse>.fromJson(
        response.data,
        (json) => WorkspaceResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> leaveWorkspace(WorkspaceIdPathParam workspaceId) async {
    try {
      await _apiClient.client.delete(ApiEndpoints.leaveWorkspace(workspaceId));

      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<WorkspaceResponse>> updateWorkspaceDetails({
    required WorkspaceIdPathParam workspaceId,
    required UpdateWorkspaceDetailsRequest payload,
  }) async {
    try {
      final response = await _apiClient.client.patch(
        ApiEndpoints.updateWorkspaceDetails(workspaceId),
        data: payload,
      );

      final apiResponse = ApiResponse<WorkspaceResponse>.fromJson(
        response.data,
        (json) => WorkspaceResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
