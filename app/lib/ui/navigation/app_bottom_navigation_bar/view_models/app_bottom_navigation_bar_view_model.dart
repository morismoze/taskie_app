import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../data/repositories/user/user_repository.dart';
import '../../../../domain/constants/rbac.dart';
import '../../../../domain/models/user.dart';
import '../../../core/services/rbac_service.dart';

class AppBottomNavigationBarViewModel extends ChangeNotifier {
  AppBottomNavigationBarViewModel({
    required String workspaceId,
    required UserRepository userRepository,
    required RbacService rbacService,
  }) : _activeWorkspaceId = workspaceId,
       _userRepository = userRepository,
       _rbacService = rbacService {
    _rbacService.addListener(_onUserChanged);
    _userRepository.addListener(_onUserChanged);
  }

  final String _activeWorkspaceId;
  final UserRepository _userRepository;
  final RbacService _rbacService;
  final _log = Logger('AppBottomNavigationBarViewModel');

  String get activeWorkspaceId => _activeWorkspaceId;

  bool get canPerformObjectiveCreation => _rbacService.hasPermission(
    permission: RbacPermission.objectiveCreate,
    workspaceId: _activeWorkspaceId,
  );

  User? get user => _userRepository.user;

  void _onUserChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  @override
  void dispose() {
    _rbacService.removeListener(_onUserChanged);
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
