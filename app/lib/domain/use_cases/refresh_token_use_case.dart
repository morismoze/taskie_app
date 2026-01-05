import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/auth/exceptions/refresh_token_failed_exception.dart';
import '../../utils/command.dart';

class RefreshTokenUseCase {
  RefreshTokenUseCase({
    required AuthRepository authRepository,
    required AuthStateRepository authStateRepository,
  }) : _authRepository = authRepository,
       _authStateRepository = authStateRepository;

  final AuthRepository _authRepository;
  final AuthStateRepository _authStateRepository;

  /// Refreshes access token via [RefreshTokenRepository] and sets authenticated state in [AuthStateRepository],
  /// meaning it sets the new tokens and, in cases of failure, sets the authenticated state to false for the
  /// gorouter redirect function to kick in.
  ///
  /// This is set in the use-case and not in AuthRepository, because repositories shouldn't depend on each other.
  /// And alse because this logic is used in bunch of places, so this acts as a single source of truth.
  Future<Result<void>> refreshAcessToken() async {
    try {
      final result = await _authRepository.refreshToken();

      switch (result) {
        case Ok():
          final (accessToken, refreshToken) = result.value;
          // Not fatal if tokens save to the secure storage fails. Worst
          // case token refresh will trigger once again.
          await _authStateRepository.setTokens((accessToken, refreshToken));
          return const Result.ok(null);
        case Error():
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
