import '../../../../utils/command.dart';
import '../api_client.dart';
import 'models/request/social_login_request.dart';
import 'models/response/login_response.dart';
import 'models/response/token_refresh_response.dart';

class AuthApiService {
  AuthApiService(ApiClient apiClient) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<LoginResponse>> login(SocialLoginRequest payload) async {
    try {
      final response = await _apiClient.client.post('/auth/google');
      return Result.ok(LoginResponse.fromJson(response.data));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<TokenRefreshResponse>> refreshToken() async {
    try {
      final response = await _apiClient.client.post('/auth/refresh');
      return Result.ok(TokenRefreshResponse.fromJson(response.data));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
