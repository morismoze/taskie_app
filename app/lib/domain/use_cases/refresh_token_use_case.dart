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
  /// This is set in the use-case and not in AuthRepository, because repositories shouldn't depend on each other.
  /// And alse because this logic is used in bunch of places, so this acts as a single source of truth.
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
          await _authStateRepository.setTokens((accessToken, refreshToken));
          return const Result.ok(null);
        case Error():
          _log.severe('Error refreshing the token', result.error);
          await _authStateRepository.setTokens(null);
          _authStateRepository.setAuthenticated(false);
          return const Result.error(RefreshTokenFailedException());
      }
    } on Exception catch (_) {
      await _authStateRepository.setTokens(null);
      _authStateRepository.setAuthenticated(false);
      return const Result.error(RefreshTokenFailedException());
    }
  }
}
