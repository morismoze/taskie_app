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
        break;
      case Error():
        _log.warning('Failed to load workspaces', result.error);
    }

    // After we initially loaded workspaces, we also need to set active workspace ID and
    // that will be done by calling [getActiveWorkspaceId] method, which will on app launch
    // read from storage.
    await _workspaceRepository.getActiveWorkspaceId();

    return result;
  }
}
