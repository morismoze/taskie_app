import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../../utils/command.dart';

class WorkspaceInviteViewModel extends ChangeNotifier {
  WorkspaceInviteViewModel({
    required String workspaceId,
    required WorkspaceInviteRepository workspaceInviteRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceInviteRepository = workspaceInviteRepository {
    createInviteLink = Command0(_createInviteLink)..execute();
  }

  final String _activeWorkspaceId;
  final WorkspaceInviteRepository _workspaceInviteRepository;
  final _log = Logger('WorkspaceInviteViewModel');

  late Command0 createInviteLink;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _createInviteLink() async {
    final result = await _workspaceInviteRepository.createWorkspaceInviteLink(
      _activeWorkspaceId,
    );

    switch (result) {
      case Ok():
        _inviteLink = result.value;
      case Error():
        _log.warning('Failed to create workspace invite link', result.error);
    }

    notifyListeners();
    return result;
  }
}
