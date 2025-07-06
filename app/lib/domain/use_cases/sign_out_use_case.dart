import 'package:logging/logging.dart';

import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../utils/command.dart';

class SignInUseCase {
  SignInUseCase({
    required AuthRepository authRepository,
    required AuthStateRepository authStateRepository,
  }) : _authRepository = authRepository,
       _authStateRepository = authStateRepository;

  final AuthRepository _authRepository;
  final AuthStateRepository _authStateRepository;

  final _log = Logger('SignInUseCase');

  /// On sign out we need to do two things: 1. trigger sign out request
  /// from [AuthRepository] and 2. remove authenticated state in [AuthStateRepository]
  Future<Result<void>> signOut() async {
    final signOutResult = await _authRepository.signOut();

    switch (signOutResult) {
      case Ok():
        _authStateRepository.setAuthenticated(null);
        return const Result.ok(null);
      case Error():
        _log.warning('Error signing in with Google', signOutResult.error);
        return Result.error(signOutResult.error);
    }
  }
}
