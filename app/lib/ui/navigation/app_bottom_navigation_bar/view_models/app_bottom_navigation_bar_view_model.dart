import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../domain/constants/rbac.dart';
import '../../../../utils/command.dart';
import '../../../core/services/rbac_service.dart';

class AppBottomNavigationBarViewModel extends ChangeNotifier {
  AppBottomNavigationBarViewModel({
    required String workspaceId,
    required RbacService rbacService,
  }) : _activeWorkspaceId = workspaceId,
       _rbacService = rbacService {
    _rbacService.addListener(_onUserChanged);
  }

  final String _activeWorkspaceId;
  final RbacService _rbacService;
  final _log = Logger('AppBottomNavigationBarViewModel');

  late Command0 loadObjectiveCreationPermission;

  String get activeWorkspaceId => _activeWorkspaceId;

  bool get canPerformObjectiveCreation => _rbacService.hasPermission(
    permission: RbacPermission.objectiveCreate,
    workspaceId: _activeWorkspaceId,
  );

  void _onUserChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _rbacService.removeListener(_onUserChanged);
    super.dispose();
  }
}
