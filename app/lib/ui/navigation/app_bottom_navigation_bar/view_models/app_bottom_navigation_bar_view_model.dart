import 'package:flutter/foundation.dart';

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

  String get activeWorkspaceId => _activeWorkspaceId;

  bool get canPerformObjectiveCreation => _rbacService.hasPermission(
    permission: RbacPermission.objectiveCreate,
    workspaceId: _activeWorkspaceId,
  );

  User? get user => _userRepository.user;

  // Used for tracking current active workspace ID per route branch. This is needed
  // becase when active workspace is changed, we then do the active workspace change
  // use case, and after that we context.go again to the tasks screen, but with
  // different workspaceId. Now this works for tasks screen, because using context.go
  // resets the state for that route branch, but state is not reset for leaderboard
  // and goals. This means that when we previously just used navigationShell.goBranch
  // this would used old state for those two branches, which is incorrect behaviour.
  // With this map we track if there was a change on the current active workspace
  // and if there was one, then we again use navigationShell.goBranch, but this time
  // with initialLocation set to true - this resets the state for that branch.
  final Map<int, String?> _lastWsForBranch = {};

  bool needsReset(int branchIndex) =>
      _lastWsForBranch[branchIndex] != _activeWorkspaceId;

  void markVisited(int branchIndex) {
    _lastWsForBranch[branchIndex] = _activeWorkspaceId;
  }

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
