import '../../../data/repositories/auth/auth_repository.dart';
import '../../../utils/command.dart';

class TasksViewModel {
  TasksViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository {
    getTasks = Command0(_getTasks);
  }

  final AuthRepository _authRepository;

  late Command0 getTasks;

  Future<Result<void>> _getTasks() async {
    final result = await _authRepository.signInWithGoogle();
    return result;
  }
}
