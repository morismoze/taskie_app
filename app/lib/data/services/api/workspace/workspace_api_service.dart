import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../api_response.dart';
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
}
