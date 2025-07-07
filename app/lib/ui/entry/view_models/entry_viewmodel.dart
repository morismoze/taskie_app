import 'package:logging/logging.dart';

import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class EntryViewModel {
  EntryViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
  }

  final WorkspaceRepository _workspaceRepository;
  final _log = Logger('EntryViewModel');

  late Command0 loadWorkspaces;

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();

    switch (result) {
      case Ok():
        _log.warning('Successfully loaded workspaces on entry screen');
        break;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    return result;
  }
}
