import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class WorkspaceInviteViewModel extends ChangeNotifier {
  WorkspaceInviteViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository {
    createInviteLink = Command0(_createInviteLink)..execute();
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceInviteViewModel');

  late Command0 createInviteLink;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _createInviteLink() async {
    final result = await _workspaceRepository.createWorkspaceInviteLink(
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
