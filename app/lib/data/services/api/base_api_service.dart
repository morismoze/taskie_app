import 'package:dio/dio.dart';

import '../../../utils/api.dart';
import '../../../utils/command.dart';
import 'api_client.dart';
import 'api_response.dart';
import 'exceptions/general_api_exception.dart';
import 'paginable.dart';

abstract class BaseApiService {
  final ApiClient apiClient;

  BaseApiService(this.apiClient);

  Future<Result<T>> executeApiCall<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJson,
  }) async {
    try {
      final response = await apiCall();

      final apiResponse = ApiResponse<T>.fromJson(
        response.data,
        (json) => fromJson(json as Map<String, dynamic>),
      );

      final data = apiResponse.data;
      if (data == null) {
        return Result.error(
          Exception('Response data is null'),
          StackTrace.current,
        );
      }

      return Result.ok(data);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError != null) {
        return Result.error(
          GeneralApiException(error: apiError, stackTrace: stackTrace),
          stackTrace,
        );
      }

      return Result.error(e, stackTrace);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<List<T>>> executeApiCallList<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJsonItem,
  }) async {
    try {
      final response = await apiCall();

      final apiResponse = ApiResponse<List<T>>.fromJson(
        response.data,
        (jsonList) => (jsonList as List)
            .map<T>((item) => fromJsonItem(item as Map<String, dynamic>))
            .toList(),
      );

      final data = apiResponse.data;
      if (data == null) {
        return Result.error(
          Exception('Response data is null'),
          StackTrace.current,
        );
      }

      return Result.ok(data);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError != null) {
        return Result.error(
          GeneralApiException(error: apiError, stackTrace: stackTrace),
          stackTrace,
        );
      }

      return Result.error(e, stackTrace);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<PaginableResponse<T>>> executeApiCallPaginable<T>({
    required Future<Response> Function() apiCall,
    required T Function(Map<String, dynamic>) fromJsonItem,
  }) async {
    try {
      final response = await apiCall();

      final apiResponse = ApiResponse<PaginableResponse<T>>.fromJson(
        response.data,
        (json) => PaginableResponse.fromJson(
          json as Map<String, dynamic>,
          (itemJson) => fromJsonItem(itemJson as Map<String, dynamic>),
        ),
      );

      final data = apiResponse.data;
      if (data == null) {
        return Result.error(
          Exception('Response data is null'),
          StackTrace.current,
        );
      }

      return Result.ok(data);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError != null) {
        return Result.error(
          GeneralApiException(error: apiError, stackTrace: stackTrace),
          stackTrace,
        );
      }

      return Result.error(e, stackTrace);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> executeVoidApiCall({
    required Future<Response> Function() apiCall,
  }) async {
    try {
      await apiCall();
      return const Result.ok(null);
    } on DioException catch (e, stackTrace) {
      final apiError = ApiUtils.getApiErrorResponse(e);

      if (apiError != null) {
        return Result.error(
          GeneralApiException(error: apiError, stackTrace: stackTrace),
          stackTrace,
        );
      }

      return Result.error(e, stackTrace);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }
}
