import 'package:logging/logging.dart';

import '../../../../domain/use_cases/sign_in_use_case.dart';
import '../../../../utils/command.dart';

class SignInViewModel {
  SignInViewModel({required SignInUseCase signInUseCase})
    : _signInUseCase = signInUseCase {
    signInWithGoogle = Command0(_signInWithGoogle);
  }

  final SignInUseCase _signInUseCase;
  final _log = Logger('SignInViewModel');

  late Command0 signInWithGoogle;

  Future<Result<void>> _signInWithGoogle() async {
    final result = await _signInUseCase.signInWithGoogle();

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to sign the user in via Google', result.error);
    }

    return result;
  }
}
