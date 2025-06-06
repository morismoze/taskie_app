import '../../../data/repositories/workspace/workspace_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

class EntryViewModel {
  EntryViewModel({required WorkspaceRepository workspaceRepository})
    : _workspaceRepository = workspaceRepository {
    loadWorkspaces = Command0(_loadWorkspaces)..execute();
  }

  final WorkspaceRepository _workspaceRepository;

  final List<Workspace> _workspaces = [];

  List<Workspace> get workspaces => _workspaces;

  late Command0 loadWorkspaces;

  Future<Result<void>> _loadWorkspaces() async {
    final result = await _workspaceRepository.getWorkspaces();
    return result;
  }
}
