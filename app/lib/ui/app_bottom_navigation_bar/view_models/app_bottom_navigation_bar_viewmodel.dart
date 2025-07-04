import 'package:flutter/material.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';

class AppBottomNavigationBarViewmodel extends ChangeNotifier {
  AppBottomNavigationBarViewmodel({
    required WorkspaceRepository workspaceRepository,
  }) : _workspaceRepository = workspaceRepository;

  final WorkspaceRepository _workspaceRepository;

  Future<String?> get activeWorkspaceId =>
      _workspaceRepository.activeWorkspaceId;
}
