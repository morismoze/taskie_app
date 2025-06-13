import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class EntryViewModel extends ChangeNotifier {
  EntryViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    load = Command0(_load)..execute();
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('EntryViewModel');

  bool _userHasNoWorkspaces = false;

  bool get userHasNoWorkspaces => _userHasNoWorkspaces;

  late Command0 load;

  Future<Result<void>> _load() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _userHasNoWorkspaces = result.value.isEmpty;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
        _userHasNoWorkspaces = false;
    }

    notifyListeners();
    return result;
  }
}
