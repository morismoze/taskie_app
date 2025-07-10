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

  Future<Result<String?>> _loadWorkspaces() async {
    final resultLoadWorkspaces = await _workspaceRepository.getWorkspaces();

    switch (resultLoadWorkspaces) {
      case Ok():
        break;
      case Error():
        _log.warning('Failed to load workspaces', resultLoadWorkspaces.error);
        return Result.error(Exception(resultLoadWorkspaces.error));
    }

    return await _workspaceRepository.getActiveWorkspaceId();
  }
}
