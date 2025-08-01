import 'package:logging/logging.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../../utils/lru_cache.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/workspace_task/models/request/create_task_request.dart';
import '../../../services/api/workspace/workspace_task/models/response/workspace_task_response.dart';
import '../../../services/api/workspace/workspace_task/workspace_task_api_service.dart';
import 'workspace_task_repository.dart';

const initLRUCacheLimitFilter = 20;

class WorkspaceTaskRepositoryImpl extends WorkspaceTaskRepository {
  WorkspaceTaskRepositoryImpl({
    required WorkspaceTaskApiService workspaceTaskApiService,
  }) : _workspaceTaskApiService = workspaceTaskApiService;

  final WorkspaceTaskApiService _workspaceTaskApiService;

  // Filter params
  ObjectiveFilter _activeFilter = ObjectiveFilter();
  final _log = Logger('WorkspaceTaskRepository');

  // A map of tasks per ObjectiveFilter
  LRUCache<ObjectiveFilter, List<WorkspaceTask>> _cachedTasksPerFilter =
      LRUCache(maxSize: initLRUCacheLimitFilter);

  @override
  List<WorkspaceTask>? get tasks => _cachedTasksPerFilter.get(_activeFilter);

  @override
  Future<Result<void>> loadTasks({
    required String workspaceId,
    bool forceFetch = false,
    ObjectiveFilter? filter,
  }) async {
    // Refetch when:
    // 1. forceFetch is `true`
    // 2. provided [filter] and class [_filter] are different
    // 3. there is no value for given [effectiveFilter] cache key

    // Either use provided filter or cached one
    final effectiveFilter = filter ?? _activeFilter;

    if (!forceFetch && _cachedTasksPerFilter.get(effectiveFilter) != null) {
      return const Result.ok(null);
    }

    if (effectiveFilter != _activeFilter) {
      _activeFilter = effectiveFilter;
    }

    try {
      final queryParams = ObjectiveRequestQueryParams(
        page: _activeFilter.page,
        limit: _activeFilter.limit,
        search: _activeFilter.search,
        status: _activeFilter.status,
      );
      final result = await _workspaceTaskApiService.getTasks(
        workspaceId: workspaceId,
        queryParams: queryParams,
      );
      switch (result) {
        case Ok<PaginableResponse<WorkspaceTaskResponse>>():
          final mappedData = result.value.items
              .map((task) => _mapTaskFromResponse(task))
              .toList();

          _cachedTasksPerFilter.put(_activeFilter, mappedData);
          notifyListeners();

          return const Result.ok(null);
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
    required int rewardPoints,
    String? description,
    DateTime? dueDate,
  }) async {
    try {
      final payload = CreateTaskRequest(
        title: title,
        assignees: assignees,
        rewardPoints: rewardPoints,
        description: description,
        dueDate: dueDate?.toIso8601String(),
      );
      final result = await _workspaceTaskApiService.createTask(
        workspaceId: workspaceId,
        payload: payload,
      );

      switch (result) {
        case Ok<WorkspaceTaskResponse>():
          final newTask = _mapTaskFromResponse(result.value, isNew: true);

          final currentTasks = _cachedTasksPerFilter.get(_activeFilter);
          if (currentTasks == null) {
            _cachedTasksPerFilter.put(_activeFilter, []);
          }

          // Add the new task with the `new` flag to the start index, so additional
          // UI styles are applied to it in the current tasks paginable page. Also
          // it is added to the current active filter key.
          final updatedTasks = [newTask, ...currentTasks!];
          _cachedTasksPerFilter.put(_activeFilter, updatedTasks);
          notifyListeners();

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
    _cachedTasksPerFilter = LRUCache(maxSize: initLRUCacheLimitFilter);
    _activeFilter = ObjectiveFilter();
  }

  WorkspaceTask _mapTaskFromResponse(
    WorkspaceTaskResponse task, {
    bool isNew = false,
  }) {
    return WorkspaceTask(
      id: task.id,
      title: task.title,
      rewardPoints: task.rewardPoints,
      assignees: task.assignees
          .map(
            (assignee) => WorkspaceTaskAssignee(
              id: assignee.id,
              firstName: assignee.firstName,
              lastName: assignee.lastName,
              status: assignee.status,
              profileImageUrl: assignee.profileImageUrl,
            ),
          )
          .toList(),
      description: task.description,
      dueDate: task.dueDate,
      isNew: isNew,
    );
  }
}
