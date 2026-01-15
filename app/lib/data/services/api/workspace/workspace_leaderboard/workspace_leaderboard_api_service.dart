import '../../../../../config/api_endpoints.dart';
import '../../../../../utils/command.dart';
import '../../api_client.dart';
import '../../base_api_service.dart';
import '../workspace/models/request/workspace_id_path_param.dart';
import 'models/response/workspace_leaderboard_user_response.dart';

class WorkspaceLeaderboardApiService extends BaseApiService {
  WorkspaceLeaderboardApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<List<WorkspaceLeaderboardUserResponse>>> loadLeaderboard(
    WorkspaceIdPathParam workspaceId,
  ) {
    return executeApiCallList(
      apiCall: () =>
          _apiClient.client.get(ApiEndpoints.getLeaderboard(workspaceId)),
      fromJsonItem: WorkspaceLeaderboardUserResponse.fromJson,
    );
  }
}
