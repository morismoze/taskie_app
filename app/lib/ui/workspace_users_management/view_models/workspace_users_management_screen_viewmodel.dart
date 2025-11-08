import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../data/services/api/user/models/response/user_response.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

class WorkspaceUsersManagementScreenViewModel extends ChangeNotifier {
  WorkspaceUsersManagementScreenViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required WorkspaceUserRepository workspaceUserRepository,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _workspaceUserRepository = workspaceUserRepository {
    _workspaceUserRepository.addListener(_onWorkspaceUsersChanged);
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)
      ..execute((workspaceId, false));
    deleteWorkspaceUser = Command1(_deleteWorkspaceUser);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final _log = Logger('WorkspaceUsersManagementScreenViewModel');

  late Command1<void, (String workspaceId, bool forceFetch)>
  loadWorkspaceMembers;
  late Command1<void, (String workspaceId, String workspaceUserId)>
  deleteWorkspaceUser;

  String get activeWorkspaceId => _activeWorkspaceId;

  User get currentUser => _userRepository.user!;

  List<WorkspaceUser>? get users {
    final workspaceUsers = _workspaceUserRepository.users;

    if (workspaceUsers == null) {
      return null;
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

  void _onWorkspaceUsersChanged() {
    notifyListeners();
  }

  Future<Result<void>> _loadWorkspaceMembers(
    (String workspaceId, bool forceFetch) details,
  ) async {
    final (workspaceId, forceFetch) = details;
    final result = await _workspaceUserRepository.loadWorkspaceUsers(
      workspaceId: workspaceId,
      forceFetch: forceFetch,
    );

    switch (result) {
      case Ok():
        notifyListeners();
        break;
      case Error():
        _log.warning('Failed to load workspace users', result.error);
    }

    return result;
  }

  Future<Result<void>> _deleteWorkspaceUser(
    (String workspaceId, String workspaceUserId) details,
  ) async {
    final (String workspaceId, String workspaceUserId) = details;
    final result = await _workspaceUserRepository.deleteWorkspaceUser(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to delete workspace user', result.error);
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
