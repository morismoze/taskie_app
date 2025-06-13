import 'package:logging/logging.dart';

import '../../data/repositories/auth/auth_repository.dart';
import '../../data/repositories/auth/auth_state_repository.dart';
import '../../data/repositories/user/user_repository.dart';
import '../../utils/command.dart';
import '../models/auth.dart';

class SignInUseCase {
  SignInUseCase({
    required AuthRepository authRepository,
    required AuthStateRepository authStateRepository,
    required UserRepository userRepository,
  }) : _authRepository = authRepository,
       _authStateRepository = authStateRepository,
       _userRepository = userRepository;

  final AuthRepository _authRepository;
  final AuthStateRepository _authStateRepository;
  final UserRepository _userRepository;

  final _log = Logger('SignInUseCase');

  /// On Google sign in we need to do three things: 1. trigger Google sign in request from [AuthRepository],
  /// 2. set authenticated state in [AuthStateRepository] and 3. set user state in [UserRepository]
  Future<Result<void>> signInWithGoogle() async {
    final signInWithGoogleResult = await _authRepository.signInWithGoogle();

    switch (signInWithGoogleResult) {
      case Ok<Auth>():
        _authStateRepository.setAuthenticated(
          SetAuthStateArgumentsTrue(
            accessToken: signInWithGoogleResult.value.accessToken,
            refreshToken: signInWithGoogleResult.value.refreshToken,
          ),
        );
        _userRepository.setUser(signInWithGoogleResult.value.user);
        return const Result.ok(null);
      case Error<Auth>():
        _log.warning(
          'Error signing in with Google',
          signInWithGoogleResult.error,
        );
        return Result.error(signInWithGoogleResult.error);
    }
  }
}
