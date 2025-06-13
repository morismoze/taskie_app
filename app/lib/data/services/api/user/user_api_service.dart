import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../api_client.dart';
import '../api_response.dart';
import 'models/response/user_response.dart';

class UserApiService {
  UserApiService({required ApiClient apiClient}) : _apiClient = apiClient;

  final ApiClient _apiClient;

  Future<Result<UserResponse>> getCurrentUser() async {
    try {
      final response = await _apiClient.client.get(ApiEndpoints.getCurrentUser);

      final apiResponse = ApiResponse<UserResponse>.fromJson(
        response.data,
        (json) => UserResponse.fromJson(json as Map<String, dynamic>),
      );

      return Result.ok(apiResponse.data!);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
