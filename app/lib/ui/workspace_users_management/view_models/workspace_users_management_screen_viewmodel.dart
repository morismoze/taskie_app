import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
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

  List<WorkspaceUser> get users {
    final workspaceUsers = _workspaceUserRepository.users;

    if (workspaceUsers == null) {
      return [];
    }

    final sortedUsers = List<WorkspaceUser>.from(workspaceUsers);

    // Users must be sorted:
    // 1. By the role - firstly Maanager roles, and then Member roles
    // 2. By firstName and lastName ASC
    sortedUsers.sort((userA, userB) {
      // 1. Sort by role
      final roleComparison = () {
        final roleA = userA.role;
        final roleB = userB.role;

        if (roleA == roleB) {
          return 0;
        }

        if (roleA == WorkspaceRole.manager) {
          return -1;
        }

        return 1;
      }();

      // If roles are different, immediately return the result
      if (roleComparison != 0) {
        return roleComparison;
      }

      // 2. Sort by firstName and lastName
      final nameA = '${userA.firstName} ${userA.lastName}'.toLowerCase();
      final nameB = '${userB.firstName} ${userB.lastName}'.toLowerCase();

      return nameA.compareTo(nameB);
    });

    return sortedUsers;
  }

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
