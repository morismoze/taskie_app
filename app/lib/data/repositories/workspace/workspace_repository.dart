import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

abstract class WorkspaceRepository {
  Future<Result<List<Workspace>>> getWorkspaces();
}
