import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class WorkspaceSettingsScreenViewModel extends ChangeNotifier {
  WorkspaceSettingsScreenViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository {
    _loadWorkspaceDetails();
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('WorkspaceSettingsScreenViewModel');

  String get activeWorkspaceId => _activeWorkspaceId;

  Workspace? _details;

  Workspace? get details => _details;

  Result<void> _loadWorkspaceDetails() {
    final result = _workspaceRepository.loadWorkspaceDetails(
      _activeWorkspaceId,
    );

    switch (result) {
      case Ok():
        _details = result.value;
        notifyListeners();
        return const Result.ok(null);
      case Error():
        _log.warning('Failed to load workspace details', result.error);
        return result;
    }
  }
}
