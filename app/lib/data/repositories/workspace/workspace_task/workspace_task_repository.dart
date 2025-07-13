import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/paginable_objectives.dart';

abstract class WorkspaceTaskRepository {
  Future<Result<List<WorkspaceTask>>> getTasks({
    required String workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
    bool forceFetch,
  });

  Future<Result<void>> createTask(
    String workspaceId, {
    required String title,
    required List<String> assignees,
    required rewardPoints,
    String? description,
    String? dueData,
  });

  void purgeTasksCache();
}
