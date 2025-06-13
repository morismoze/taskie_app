import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../api_response.dart';
import 'models/request/create_workspace_request.dart';
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
            .map<WorkspaceResponse>((json) => WorkspaceResponse.fromJson(json))
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
}
