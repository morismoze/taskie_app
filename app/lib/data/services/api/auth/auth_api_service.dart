import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../../../repositories/auth/auth_id_provider_repository.dart';
import '../api_client.dart';
import '../base_api_service.dart';
import 'models/request/refresh_token_request.dart';
import 'models/request/social_login_request.dart';
import 'models/response/login_response.dart';
import 'models/response/refresh_token_response.dart';

class AuthApiService extends BaseApiService {
  AuthApiService({required ApiClient apiClient})
    : _apiClient = apiClient,
      super(apiClient);

  final ApiClient _apiClient;

  Future<Result<LoginResponse>> login({
    required AuthProvider provider,
    required SocialLoginRequest payload,
  }) {
    return executeApiCall(
      apiCall: () => _apiClient.client.post(
        ApiEndpoints.socialLogin(provider),
        data: payload,
      ),
      fromJson: LoginResponse.fromJson,
    );
  }

  Future<Result<void>> logout() {
    return executeVoidApiCall(
      apiCall: () => _apiClient.client.delete(ApiEndpoints.logout),
    );
  }

  Future<Result<RefreshTokenResponse>> refreshAccessToken(
    RefreshTokenRequest payload,
  ) {
    return executeApiCall(
      apiCall: () =>
          _apiClient.client.post(ApiEndpoints.logout, data: payload.toJson()),
      fromJson: RefreshTokenResponse.fromJson,
    );
  }
}
