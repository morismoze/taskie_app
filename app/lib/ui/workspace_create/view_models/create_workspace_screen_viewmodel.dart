import 'package:flutter/foundation.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/create_workspace_use_case.dart';
import '../../../domain/use_cases/join_workspace_use_case.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';

class CreateWorkspaceScreenViewModel extends ChangeNotifier {
  CreateWorkspaceScreenViewModel({
    required WorkspaceRepository workspaceRepository,
    required UserRepository userRepository,
    required CreateWorkspaceUseCase createWorkspaceUseCase,
    required JoinWorkspaceUseCase joinWorkspaceUseCase,
  }) : _workspaceRepository = workspaceRepository,
       _userRepository = userRepository,
       _createWorkspaceUseCase = createWorkspaceUseCase,
       _joinWorkspaceUseCase = joinWorkspaceUseCase {
    _loadUser();
    _loadWorkspaces();
    createWorkspace = Command1(_createWorkspace);
    joinWorkspaceViaInviteLink = Command1(_joinWorkspaceViaInviteLink);
  }

  final WorkspaceRepository _workspaceRepository;
  final UserRepository _userRepository;
  final CreateWorkspaceUseCase _createWorkspaceUseCase;
  final JoinWorkspaceUseCase _joinWorkspaceUseCase;

  /// Returns ID of the newly created workspace
  late Command1<String, (String name, String? description)> createWorkspace;
  late Command1<String, String> joinWorkspaceViaInviteLink;

  User? _user;

  User? get user => _user;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  Future<Result<void>> _loadUser() async {
    final result = await _userRepository.loadUser();

    switch (result) {
      case Ok():
        _user = result.value;
        notifyListeners();
      case Error():
    }

    notifyListeners();
    return result;
  }

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.loadWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
      case Error():
    }

    notifyListeners();
    return result;
  }

  Future<Result<String>> _createWorkspace(
    (String name, String? description) details,
  ) async {
    final (name, description) = details;
    final resultCreate = await _createWorkspaceUseCase.createWorkspace(
      name: name,
      description: description,
    );

    return resultCreate;
  }

  Future<Result<String>> _joinWorkspaceViaInviteLink(String inviteLink) async {
    try {
      final inviteToken = inviteLink.split(
        '${Routes.workspaceJoinRelative}/',
      )[1];

      // This case should never happen because of the specific
      // validation of the invite link field.
      if (inviteToken.isEmpty) {
        return Result.error(Exception('Invalid invite link'));
      }

      return await _joinWorkspaceUseCase.joinWorkspace(inviteToken);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
