import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class WorkspaceInviteViewModel extends ChangeNotifier {
  WorkspaceInviteViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    createInviteLink = Command1(_createInviteLink);
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceInviteViewModel');

  late Command1<void, String> createInviteLink;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _createInviteLink(String workspaceId) async {
    final result = await _workspaceRepository.createWorkspaceInviteLink(
      workspaceId: workspaceId,
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
