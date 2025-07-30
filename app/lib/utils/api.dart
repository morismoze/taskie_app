import 'package:dio/dio.dart';

import '../data/services/api/api_response.dart';

abstract final class ApiUtils {
  static ApiError? getApiErrorResponse(DioException dioException) {
    final response = dioException.response;

    if (response == null) {
      return null;
    }

    final errorResponse = ApiResponse<dynamic>.fromJson(
      response.data,
      (json) => null,
    );
    final errorResponseBody = errorResponse.error!;

    return errorResponseBody;
  }
}
