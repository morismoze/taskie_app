import '../../../../data/repositories/auth/auth_id_provider_repository.dart';
import '../../../../domain/use_cases/sign_in_use_case.dart';
import '../../../../utils/command.dart';

class SignInScreenViewModel {
  SignInScreenViewModel({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase {
    signInWithGoogle = Command0(_signInWithGoogle);
  }

  final SignInUseCase _signInUseCase;

  late Command0 signInWithGoogle;

  Future<Result<void>> _signInWithGoogle() async {
    final result = await _signInUseCase.signIn(AuthProvider.google);

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }
}
