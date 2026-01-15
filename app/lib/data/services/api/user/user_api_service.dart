import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../base_api_service.dart';
import 'models/response/user_response.dart';

class UserApiService extends BaseApiService {
  UserApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<UserResponse>> getCurrentUser() {
    return executeApiCall(
      apiCall: () => _apiClient.client.get(ApiEndpoints.getCurrentUser),
      fromJson: UserResponse.fromJson,
    );
  }

  Future<Result<void>> deleteAccount() {
    return executeVoidApiCall(
      apiCall: () => _apiClient.client.delete(ApiEndpoints.deleteAccount),
    );
  }
}
