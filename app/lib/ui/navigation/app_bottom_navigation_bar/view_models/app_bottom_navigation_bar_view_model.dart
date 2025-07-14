import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../../../domain/constants/rbac.dart';
import '../../../../domain/use_cases/rbac_use_case.dart';
import '../../../../utils/command.dart';

class AppBottomNavigationBarViewModel extends ChangeNotifier {
  AppBottomNavigationBarViewModel({
    required String workspaceId,
    required RbacUseCase rbacUseCase,
  }) : _activeWorkspaceId = workspaceId,
       _rbacUseCase = rbacUseCase {
    loadObjectiveCreationPermission = Command0(_loadObjectiveCreationPermission)
      ..execute();
  }

  final String _activeWorkspaceId;
  final RbacUseCase _rbacUseCase;
  final _log = Logger('AppBottomNavigationBarViewModel');

  late Command0 loadObjectiveCreationPermission;

  String get activeWorkspaceId => _activeWorkspaceId;

  bool _canPerformObjectiveCreation = false;

  bool get canPerformObjectiveCreation => _canPerformObjectiveCreation;

  Future<Result<void>> _loadObjectiveCreationPermission() async {
    final result = await _rbacUseCase.canPerformAction(
      permission: RbacPermission.objectiveCreate,
      workspaceId: _activeWorkspaceId,
    );
    switch (result) {
      case Ok():
        _canPerformObjectiveCreation = result.value;
        notifyListeners();
      case Error():
        _log.warning(
          'Failed to load objective creation permission',
          result.error,
        );
    }

    return result;
  }
}
