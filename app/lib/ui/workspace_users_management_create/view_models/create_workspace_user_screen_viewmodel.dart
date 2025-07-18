import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../utils/command.dart';

class CreateWorkspaceUserScreenViewModel extends ChangeNotifier {
  CreateWorkspaceUserScreenViewModel({
    required String workspaceId,
    required WorkspaceInviteRepository workspaceInviteRepository,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceInviteRepository = workspaceInviteRepository,
       _workspaceUserRepository = workspaceUserRepository {
    createInviteLink = Command0(_createInviteLink)..execute();
    createVirtualUser = Command1(_createVirtualUser);
  }

  final String _activeWorkspaceId;
  final WorkspaceInviteRepository _workspaceInviteRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('CreateWorkspaceUserScreenViewModel');

  /// Returns invite link
  late Command0<String> createInviteLink;
  late Command1<void, (String, String)> createVirtualUser;

  String get activeWorkspaceId => _activeWorkspaceId;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<String>> _createInviteLink() async {
    final result = await _workspaceInviteRepository.createWorkspaceInviteLink(
      _activeWorkspaceId,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to create workspace invite link', result.error);
    }

    return result;
  }

  Future<Result<void>> _createVirtualUser(
    (String firstName, String lastName) details,
  ) async {
    final (firstName, lastName) = details;
    final result = await _workspaceUserRepository.createVirtualMember(
      workspaceId: _activeWorkspaceId,
      firstName: firstName,
      lastName: lastName,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to create virtual user', result.error);
    }

    return result;
  }
}
