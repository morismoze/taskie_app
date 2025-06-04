import '../../../../data/repositories/auth/auth_repository.dart';
import '../../../../utils/command.dart';

class LoginViewModel {
  LoginViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    signInWithGoogle = Command0(_signInWithGoogle);
  }

  final AuthRepository _authRepository;

  late Command0 signInWithGoogle;

  Future<Result<void>> _signInWithGoogle() async {
    final result = await _authRepository.signInWithGoogle();
    return result;
  }
}
