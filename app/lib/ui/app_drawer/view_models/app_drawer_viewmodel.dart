import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _workspaces = result.value;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    notifyListeners();
    return result;
  }
}
