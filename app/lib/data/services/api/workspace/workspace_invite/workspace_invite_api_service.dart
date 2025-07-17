import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../api_response.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/create_workspace_invite_link_response.dart';

class WorkspaceInviteApiService {
  WorkspaceInviteApiService({required ApiClient apiClient})
    : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<CreateWorkspaceInviteLinkResponse>> createWorkspaceInviteLink(
    WorkspaceIdPathParam workspaceId,
  ) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.createWorkspaceInviteLink(workspaceId),
      );

      final apiResponse =
          ApiResponse<CreateWorkspaceInviteLinkResponse>.fromJson(
            response.data,
            (json) => CreateWorkspaceInviteLinkResponse.fromJson(
              json as Map<String, dynamic>,
            ),
          );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
