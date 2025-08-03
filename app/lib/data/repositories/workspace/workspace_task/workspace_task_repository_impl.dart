import 'package:logging/logging.dart';

import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/progress_status.dart';
import '../../../services/api/workspace/workspace_task/models/request/create_task_request.dart';
import '../../../services/api/workspace/workspace_task/models/response/workspace_task_response.dart';
import '../../../services/api/workspace/workspace_task/workspace_task_api_service.dart';
import 'workspace_task_repository.dart';

const _kDefaultPaginablePage = 1;
const _kDefaultPaginableLimit = 15;
const _kDefaultPaginableStatus = ProgressStatus.inProgress;
const _kDefaultPaginableSort = SortBy.newestFirst;

class WorkspaceTaskRepositoryImpl extends WorkspaceTaskRepository {
  WorkspaceTaskRepositoryImpl({
    required WorkspaceTaskApiService workspaceTaskApiService,
  }) : _workspaceTaskApiService = workspaceTaskApiService;

  final WorkspaceTaskApiService _workspaceTaskApiService;

  final _log = Logger('WorkspaceTaskRepository');

  bool _isInitialLoad = true;

  @override
  bool get isInitialLoad => _isInitialLoad;

  ObjectiveFilter _activeFilter = ObjectiveFilter(
    page: _kDefaultPaginablePage,
    limit: _kDefaultPaginableLimit,
    status: _kDefaultPaginableStatus,
    sort: _kDefaultPaginableSort,
  );

  @override
  ObjectiveFilter get activeFilter => _activeFilter;

  // LRUCache would make sense here for infinite pagination, not for standard pagination
  Paginable<WorkspaceTask>? _cachedTasks;

  @override
  Paginable<WorkspaceTask>? get tasks => _cachedTasks;

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

    if (!forceFetch &&
        effectiveFilter == _activeFilter &&
        _cachedTasks != null) {
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
        sort: _activeFilter.sort,
      );
      final result = await _workspaceTaskApiService.getTasks(
        workspaceId: workspaceId,
        queryParams: queryParams,
      );
      switch (result) {
        case Ok<PaginableResponse<WorkspaceTaskResponse>>():
          final items = result.value.items;
          final totalPages = result.value.totalPages;
          final total = result.value.total;
          final mappedData = items
              .map((task) => _mapTaskFromResponse(task))
              .toList();
          final paginable = Paginable(
            items: mappedData,
            totalPages: totalPages,
            total: total,
          );

          _cachedTasks = paginable;
          if (_isInitialLoad) {
            _isInitialLoad = false;
          }
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
          // Add the new task with the `isNew` flag, so additional
          // UI styles are applied to it in the current tasks paginable page.
          // Also it is added to the current active filter key.
          final newTask = _mapTaskFromResponse(result.value, isNew: true);

          // [_cachedTasks] should always be != null at this point in time, because
          // we show a error prompt with retry on the TasksScreen if there was a problem
          // with initial tasks load from origin.
          _cachedTasks = _cachedTasks!.addItem(newTask);
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
    _cachedTasks = null;
    _activeFilter = ObjectiveFilter(
      page: _kDefaultPaginablePage,
      limit: _kDefaultPaginableLimit,
      status: _kDefaultPaginableStatus,
      sort: _kDefaultPaginableSort,
    );
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
      createdAt: task.createdAt,
      description: task.description,
      dueDate: task.dueDate,
      isNew: isNew,
    );
  }
}
