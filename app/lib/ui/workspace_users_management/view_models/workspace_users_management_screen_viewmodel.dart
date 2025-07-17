import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class WorkspaceUsersScreenManagementViewModel extends ChangeNotifier {
  WorkspaceUsersScreenManagementViewModel({
    required String workspaceId,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceUserRepository = workspaceUserRepository {
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute(workspaceId);
  }

  final String _activeWorkspaceId;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('WorkspaceUsersScreenManagementViewModel');

  late Command1<void, String> loadWorkspaceMembers;

  String get activeWorkspaceId => _activeWorkspaceId;

  List<WorkspaceUser> get users => _workspaceUserRepository.users ?? [];

  Future<Result<void>> _loadWorkspaceMembers(String workspaceId) async {
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspace users', result.error);
    }

    return result;
  }
}
