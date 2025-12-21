import '../../data/repositories/auth/auth_id_provider_repository.dart';
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

  /// On Sign in we need to do three things:
  /// 1. trigger sign in from [AuthRepository],
  /// 2. set authenticated state in [AuthStateRepository] and
  /// 3. set user state in [UserRepository]
  Future<Result<void>> signIn(AuthProvider provider) async {
    final resultSignIn = await _authRepository.signIn(provider);

    switch (resultSignIn) {
      case Ok<Auth>():
        _authStateRepository.setTokens((
          resultSignIn.value.accessToken,
          resultSignIn.value.refreshToken,
        ));
        _authStateRepository.setAuthenticated(true);
        _userRepository.setUser(resultSignIn.value.user);
        return const Result.ok(null);
      case Error<Auth>():
        return Result.error(resultSignIn.error);
    }
  }
}
