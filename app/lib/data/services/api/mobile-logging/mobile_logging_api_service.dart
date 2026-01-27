import 'package:dio/dio.dart';

import '../../../../config/api_endpoints.dart';
import '../../../../utils/command.dart';
import '../mobile_logging_api_client.dart';
import 'models/request/create_mobile_log_request.dart';

class MobileLoggingApiService {
  MobileLoggingApiService({required MobileLoggingApiClient apiClient})
    : _apiClient = apiClient;

  final MobileLoggingApiClient _apiClient;

  Future<Result<void>> createMobileLog(CreateMobileLogRequest payload) async {
    try {
      await _apiClient.client.post(
        ApiEndpoints.createMobileLog,
        data: payload.toJson(),
      );
      return const Result.ok(null);
    } on DioException {
      // Do nothing
      return const Result.ok(null);
    } on Exception {
      // Do nothing
      return const Result.ok(null);
    }
  }
}
