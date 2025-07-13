import 'package:logging/logging.dart';

import '../../../../domain/models/assignee.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/workspace_task/models/request/create_task_request.dart';
import '../../../services/api/workspace/workspace_task/models/response/workspace_task_response.dart';
import '../../../services/api/workspace/workspace_task/workspace_task_api_service.dart';
import 'workspace_task_repository.dart';

class WorkspaceTaskRepositoryImpl extends WorkspaceTaskRepository {
  WorkspaceTaskRepositoryImpl({
    required WorkspaceTaskApiService workspaceTaskApiService,
  }) : _workspaceTaskApiService = workspaceTaskApiService;

  final WorkspaceTaskApiService _workspaceTaskApiService;

  final _log = Logger('WorkspaceTaskRepository');
  List<WorkspaceTask>? _cachedTasks;

  @override
  Future<Result<List<WorkspaceTask>>> getTasks({
    required String workspaceId,
    required PaginableObjectivesRequestQueryParams paginable,
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedTasks != null) {
      return Result.ok(_cachedTasks!);
    }

    try {
      final result = await _workspaceTaskApiService.getTasks(
        workspaceId: workspaceId,
        paginable: paginable,
      );
      switch (result) {
        case Ok<PaginableResponse<WorkspaceTaskResponse>>():
          final mappedData = result.value.items
              .map(
                (task) => WorkspaceTask(
                  id: task.id,
                  title: task.title,
                  rewardPoints: task.rewardPoints,
                  assignees: task.assignees
                      .map(
                        (assignee) => Assignee(
                          id: assignee.id,
                          firstName: assignee.firstName,
                          lastName: assignee.lastName,
                          status: assignee.status,
                        ),
                      )
                      .toList(),
                ),
              )
              .toList();
          _cachedTasks = mappedData;

          return Result.ok(mappedData);
        case Error<PaginableResponse<WorkspaceTaskResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> createTask(
    String workspaceId, {
    required String title,
    required List<String> assignees,
    required rewardPoints,
    String? description,
    String? dueData,
  }) async {
    try {
      final payload = CreateTaskRequest(
        title: title,
        assignees: assignees,
        rewardPoints: rewardPoints,
        description: description,
        dueDate: dueData,
      );
      final result = await _workspaceTaskApiService.createTask(
        workspaceId: workspaceId,
        payload: payload,
      );

      switch (result) {
        case Ok<WorkspaceTaskResponse>():
          return const Result.ok(null);
        case Error<WorkspaceTaskResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  void purgeTasksCache() {
    _cachedTasks = null;
  }
}
