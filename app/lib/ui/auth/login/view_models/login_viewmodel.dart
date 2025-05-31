import '../../../../data/repositories/auth/auth_repository_impl.dart';
import '../../../../utils/command.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    loginWithGoogle = Command0(_loginWithGoogle);
  }

  final AuthRepository _authRepository;

  late Command0 loginWithGoogle;

  Future<Result<void>> _loginWithGoogle() async {
    final result = await _authRepository.loginWithGoogle();
    return result;
  }
}
