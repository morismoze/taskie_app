import 'package:dio/dio.dart';

import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../api_response.dart';
import 'models/request/social_login_request.dart';
import 'models/response/login_response.dart';
import 'models/response/refresh_token_response.dart';

/// Adds the `Authorization` header with refresh token to a header configuration.
typedef RefreshHeaderProvider = String? Function();

class AuthApiService {
  AuthApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  RefreshHeaderProvider? _refreshHeaderProvider;

  set refreshHeaderProvider(RefreshHeaderProvider refreshHeaderProvider) {
    _refreshHeaderProvider = refreshHeaderProvider;
  }

  Future<Result<LoginResponse>> login(SocialLoginRequest payload) async {
    try {
      final response = await _apiClient.client.post(
        ApiEndpoints.loginGoogle,
        data: payload,
      );

      final apiResponse = ApiResponse<LoginResponse>.fromJson(
        response.data,
        (json) => LoginResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<void>> logout() async {
    try {
      await _apiClient.client.delete(ApiEndpoints.logout);
      return const Result.ok(null);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  Future<Result<RefreshTokenResponse>> refreshAccessToken() async {
    try {
      final refreshToken = _refreshHeaderProvider?.call();
      final response = await _apiClient.client.post(
        ApiEndpoints.refreshToken,
        options: Options(headers: {'Authorization': refreshToken}),
      );

      final apiResponse = ApiResponse<RefreshTokenResponse>.fromJson(
        response.data,
        (json) => RefreshTokenResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
