import 'package:flutter/foundation.dart';

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
    loadWorkspaceMembers = Command1(_loadWorkspaceMembers)..execute(null);
    deleteWorkspaceUser = Command1(_deleteWorkspaceUser);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final WorkspaceUserRepository _workspaceUserRepository;

  /// bool force fetch argument
  late Command1<void, bool?> loadWorkspaceMembers;

  /// String workspaceUserId argument
  late Command1<void, String> deleteWorkspaceUser;

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

  Future<Result<void>> _loadWorkspaceMembers(bool? forceFetch) async {
    final result = await firstOkOrLastError(
      _workspaceUserRepository.loadWorkspaceUsers(
        workspaceId: _activeWorkspaceId,
        forceFetch: forceFetch ?? false,
      ),
    );

    switch (result) {
      case Ok():
        notifyListeners();
        break;
      case Error():
    }

    return result;
  }

  Future<Result<void>> _deleteWorkspaceUser(String workspaceUserId) async {
    final result = await _workspaceUserRepository.deleteWorkspaceUser(
      workspaceId: _activeWorkspaceId,
      workspaceUserId: workspaceUserId,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceUserRepository.removeListener(_onWorkspaceUsersChanged);
    super.dispose();
  }
}
