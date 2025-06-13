import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

abstract class WorkspaceRepository {
  Future<Result<List<Workspace>>> getWorkspaces();

  Future<Result<void>> createWorkspace({
    required String name,
    String? description,
  });
}
