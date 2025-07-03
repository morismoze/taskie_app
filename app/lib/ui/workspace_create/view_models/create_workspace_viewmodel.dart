import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../utils/command.dart';

class CreateWorkspaceViewModel extends ChangeNotifier {
  CreateWorkspaceViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository {
    load = Command0(_load)..execute();
    createWorkspace = Command1(_createWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final _log = Logger('CreateWorkspaceViewModel');

  late Command0 load;
  late Command1<void, (String name, String? description)> createWorkspace;

  User? _user;

  User? get user => _user;

  Future<Result<void>> _load() async {
    final result = await _userRepository.getUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
        _log.warning('Failed to load user', result.error);
    }

    return result;
  }

  Future<Result<void>> _createWorkspace((String, String?) credentials) async {
    final (name, description) = credentials;
    final result = await _workspaceRepository.createWorkspace(
      name: name,
      description: description,
    );
    return result;
  }
}
