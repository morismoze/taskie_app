import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import '../../../data/repositories/user/user_repository.dart';
import '../../../domain/constants/rbac.dart';

/// This is another layer of abstraction used as user repository
/// notification forwarding for Rbac. It is necessary to be a
/// [ChangeNotifier] because it has to listen to [UserRepository]
/// (which is also a [ChangeNotifier]) for possible roles updates
/// when user does pull-to-refresh. For this reason, it is not
/// a use-case, but rather a service.
class RbacService extends ChangeNotifier {
  RbacService({required UserRepository userRepository})
    : _userRepository = userRepository {
    _userRepository.addListener(_onUserChanged);
  }

  final UserRepository _userRepository;

  void _onUserChanged() {
    // Forward the notification to this class listeners (Rbac widget)
    notifyListeners();
  }

  bool hasPermission({
    required RbacPermission permission,
    required String? workspaceId,
  }) {
    final currentUser = _userRepository.user;

    if (currentUser == null) {
      return false;
    }

    final workspaceRole = currentUser.roles.firstWhereOrNull(
      (role) => role.workspaceId == workspaceId,
    );

    if (workspaceRole == null) {
      return false;
    }

    return RbacConfig.hasPermission(workspaceRole.role, permission);
  }

  @override
  void dispose() {
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
