import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class AppDrawerViewModel extends ChangeNotifier {
  AppDrawerViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    loadWorkspaces = Command0(_loadWorkspaces);
    leaveWorkspace = Command1(_leaveWorkspace);
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('AppDrawerViewModel');

  late Command0 loadWorkspaces;
  late Command1<void, String> leaveWorkspace;

  List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  Future<String?> get activeWorkspaceId =>
      _workspaceRepository.activeWorkspaceId;

  String? _inviteLink;

  String? get inviteLink => _inviteLink;

  Future<Result<void>> _loadWorkspaces({bool forceFetch = false}) async {
    final result = await _workspaceRepository.getWorkspaces(
      forceFetch: forceFetch,
    );

    switch (result) {
      case Ok():
        _workspaces = result.value;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    notifyListeners();
    return result;
  }

  Future<Result<void>> _leaveWorkspace(String workspaceId) async {
    final result = await _workspaceRepository.leaveWorkspace(
      workspaceId: workspaceId,
    );

    // After leaving the workspace we need to re-fetch workspaces
    switch (result) {
      case Ok():
        _loadWorkspaces(forceFetch: true);
      case Error():
        _log.warning('Failed to create workspace invite link', result.error);
    }

    notifyListeners();
    return result;
  }
}
