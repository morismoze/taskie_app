import '../../../data/repositories/auth/auth_state_repository.dart';
import '../../../data/repositories/client_info/client_info_repository.dart';
import '../../../utils/command.dart';

class AppStartupViewModel {
  AppStartupViewModel({
    required AuthStateRepository authStateRepository,
    required ClientInfoRepository clientInfoRepository,
  }) : _authStateRepository = authStateRepository,
       _clientInfoRepository = clientInfoRepository {
    bootstrap = Command0(_bootstrap)..execute();
  }

  final AuthStateRepository _authStateRepository;
  final ClientInfoRepository _clientInfoRepository;

  late Command0 bootstrap;

  Future<Result<void>> _bootstrap() async {
    // No need to check the result. This will either set the [isAuthenticated]
    // state to `true` or it will remain to `false`. That state will then be
    // inspected by the gorouter redirect function when gorouter builds the routes
    // initially.
    await _authStateRepository.loadAuthenticatedState();

    // Init client info
    final clientInfoInitResult = await _clientInfoRepository
        .initializeClientInfo();

    switch (clientInfoInitResult) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return Result.error(
          clientInfoInitResult.error,
          clientInfoInitResult.stackTrace,
        );
    }
  }
}
