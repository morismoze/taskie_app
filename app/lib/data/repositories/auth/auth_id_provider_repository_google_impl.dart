import '../../../logger/logger_interface.dart';
import '../../../utils/command.dart';
import '../../services/external/google/google_auth_service.dart';
import 'auth_id_provider_repository.dart';

class AuthGoogleIdProviderRepositoryImpl implements AuthIdProviderRepository {
  AuthGoogleIdProviderRepositoryImpl({
    required GoogleAuthService googleAuthService,
    required LoggerService loggerService,
  }) : _googleAuthService = googleAuthService,
       _loggerService = loggerService;

  final GoogleAuthService _googleAuthService;
  final LoggerService _loggerService;

  @override
  AuthProvider get type => AuthProvider.google;

  @override
  Future<Result<ExternalCredential>> signIn() async {
    final result = await _googleAuthService.authenticate();

    switch (result) {
      case Ok<String>():
        final idToken = result.value;
        return Result.ok(ExternalCredential(idToken: idToken));
      case Error<String>():
        _loggerService.log(
          LogLevel.warn,
          'googleAuthService.authenticate failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'AuthGoogleIdProviderRepositoryImpl',
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> signOut() => _googleAuthService.disconnect();
}
