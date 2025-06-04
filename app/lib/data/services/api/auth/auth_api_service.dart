import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import 'models/request/social_login_request.dart';
import 'models/response/login_response.dart';

class AuthApiService {
  AuthApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<LoginResponse>> login(SocialLoginRequest payload) async {
    try {
      final response = await _apiClient.client.post(ApiEndpoints.loginGoogle);
      return Result.ok(LoginResponse.fromJson(response.data));
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _apiClient.client.delete(ApiEndpoints.logout);
      return Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
