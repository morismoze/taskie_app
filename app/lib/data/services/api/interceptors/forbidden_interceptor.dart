import 'package:dio/dio.dart';

import '../../local/auth_event_bus.dart';
import '../api_response.dart';

class ForbiddenInterceptor extends Interceptor {
  ForbiddenInterceptor({required AuthEventBus authEventBus})
    : _authEventBus = authEventBus;

  final AuthEventBus _authEventBus;

  // Semaphore to lock other 403 requests.
  bool _isForbiddenLocked = false;

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 403) {
      final json = err.response?.data;

      if (json is Map<String, dynamic>) {
        try {
          final apiResponse = ApiResponse<dynamic>.fromJson(
            json,
            (json) => null, // Data is null in error cases
          );

          final error = apiResponse.error;

          if (error?.code == ApiErrorCode.workspaceAccessRevoked ||
              error?.code == ApiErrorCode.insufficientPermissions) {
            if (_isForbiddenLocked) {
              // Forward the response
              return handler.next(err);
            }

            _isForbiddenLocked = true;

            if (error?.code == ApiErrorCode.workspaceAccessRevoked) {
              _authEventBus.emit(UserRemovedFromWorkspaceEvent());
            } else {
              _authEventBus.emit(UserRoleChangedEvent());
            }

            // Resetting the semaphore - 3 seconds is just a reasonable time interval
            // in which could all other requests fail with 403 as well, and we want
            // that to be ignored.
            Future.delayed(const Duration(seconds: 3), () {
              _isForbiddenLocked = false;
            });

            // Forward the response
            return handler.next(err);
          }
        } catch (e) {
          return handler.next(err);
        }
      }
    }

    return handler.next(err);
  }
}
