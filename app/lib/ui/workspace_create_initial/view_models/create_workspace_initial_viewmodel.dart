import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/use_cases/create_workspace_use_case.dart';
import '../../../utils/command.dart';

class CreateWorkspaceInitialScreenViewModel extends ChangeNotifier {
  CreateWorkspaceInitialScreenViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required CreateWorkspaceUseCase createWorkspaceUseCase,
  }) : _userRepository = userRepository,
       _createWorkspaceUseCase = createWorkspaceUseCase {
    createWorkspace = Command1(_createWorkspace);
    _loadUser();
  }

  final UserRepository _userRepository;
  final CreateWorkspaceUseCase _createWorkspaceUseCase;
  final _log = Logger('CreateWorkspaceInitialScreenViewModel');

  late Command0 loadUser;

  /// Returns ID of the newly created workspace
  late Command1<void, (String name, String? description)> createWorkspace;

  User? _user;

  User? get user => _user;

  Future<Result<void>> _loadUser() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load user', result.error);
    }

    notifyListeners();
    return result;
  }

  Future<Result<void>> _createWorkspace((String, String?) details) async {
    final (name, description) = details;

    final resultCreate = await _createWorkspaceUseCase.createWorkspace(
      name: name,
      description: description,
    );

    return resultCreate;
  }
}
