import 'package:logging/logging.dart';

import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/auth/exceptions/refresh_token_failed_exception.dart';
import '../../data/services/api/auth/auth_api_service.dart';
import '../../data/services/api/auth/models/request/refresh_token_request.dart';
import '../../utils/command.dart';

class RefreshTokenUseCase {
  RefreshTokenUseCase({
    required AuthApiService authApiService,
    required AuthStateRepository authStateRepository,
  }) : _authApiService = authApiService,
       _authStateRepository = authStateRepository;

  final AuthApiService _authApiService;
  final AuthStateRepository _authStateRepository;

  final _log = Logger('RefreshTokenUseCase');

  /// Refreshes access token via [AuthApiService] and sets authenticated state in [AuthStateRepository].
  /// This is set in the use-case and not in AuthRepository, because repositories shoudln't depend on each other.
  Future<Result<void>> refreshAcessToken() async {
    try {
      final (_, refreshToken) = await _authStateRepository.tokens;
      final result = await _authApiService.refreshAccessToken(
        RefreshTokenRequest(refreshToken),
      );

      switch (result) {
        case Ok():
          final accessToken = result.value.accessToken;
          final refreshToken = result.value.refreshToken;
          _authStateRepository.setAuthenticated((accessToken, refreshToken));
          return const Result.ok(null);
        case Error():
          _log.severe('Error refreshing the token', result.error);
          _authStateRepository.setAuthenticated(null);
          return const Result.error(RefreshTokenFailedException());
      }
    } on Exception catch (_) {
      _authStateRepository.setAuthenticated(null);
      return const Result.error(RefreshTokenFailedException());
    }
  }
}
