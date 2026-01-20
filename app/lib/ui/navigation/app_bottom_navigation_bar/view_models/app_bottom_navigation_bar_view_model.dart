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
  // this would used old state for those two branches, which is incorrect behaviour,
  // because those screens and their VMs wouldn't get re-instantiated and thus not
  // fetch data for new active workspace ID. Please also check logic in
  // AppBottomNavigationBar's _navigateToBranch method implementation.
  // Logic:
  // 1. If a tab hasn't been visited yet for this workspace (needsReset = true),
  //    we use `context.go`. This performs a "Hard Navigation", ensuring the Router
  //    correctly matches the URL and initializes the route stack for that branch.
  // 2. If a tab has already been visited (needsReset = false), we use
  //    `navigationShell.goBranch`. This performs a "Soft Switch", preserving
  //    the state (scroll position, text inputs, etc.) of that branch.
  final Map<int, String?> _lastWsForBranch = {};

  String? _lastActiveWorkspaceId;

  bool needsReset(int branchIndex) {
    if (_lastActiveWorkspaceId != _activeWorkspaceId) {
      // Clear the map after workspace ID has been changed
      _lastWsForBranch.clear();
      _lastActiveWorkspaceId = _activeWorkspaceId;
    }

    return _lastWsForBranch[branchIndex] != _activeWorkspaceId;
  }

  void markVisited(int branchIndex) {
    _lastWsForBranch[branchIndex] = _activeWorkspaceId;
    _lastActiveWorkspaceId = _activeWorkspaceId;
  }

  void _onUserChanged() {
    // Forward the change notification from repository to the view
    notifyListeners();
  }

  @override
  void dispose() {
    _rbacService.removeListener(_onUserChanged);
    _userRepository.removeListener(_onUserChanged);
    super.dispose();
  }
}
