import 'package:collection/collection.dart';

import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_task.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/value_patch.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/progress_status.dart';
import '../../../services/api/workspace/workspace_task/models/request/add_task_assignee_request.dart';
import '../../../services/api/workspace/workspace_task/models/request/create_task_request.dart';
import '../../../services/api/workspace/workspace_task/models/request/remove_task_assignee_request.dart';
import '../../../services/api/workspace/workspace_task/models/request/update_task_assignments_request.dart';
import '../../../services/api/workspace/workspace_task/models/request/update_task_details_request.dart';
import '../../../services/api/workspace/workspace_task/models/response/add_task_assignee_response.dart';
import '../../../services/api/workspace/workspace_task/models/response/update_task_assignment_response.dart';
import '../../../services/api/workspace/workspace_task/models/response/workspace_task_response.dart';
import '../../../services/api/workspace/workspace_task/workspace_task_api_service.dart';
import '../../../services/local/database_service.dart';
import '../../../services/local/logger_service.dart';
import 'workspace_task_repository.dart';

final _defaultFilter = ObjectiveFilter(
  page: 1,
  limit: 15,
  sort: SortBy.newestFirst,
);

class WorkspaceTaskRepositoryImpl extends WorkspaceTaskRepository {
  WorkspaceTaskRepositoryImpl({
    required WorkspaceTaskApiService workspaceTaskApiService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _workspaceTaskApiService = workspaceTaskApiService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final WorkspaceTaskApiService _workspaceTaskApiService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  bool _isFilterSearch = false;

  @override
  bool get isFilterSearch => _isFilterSearch;

  ObjectiveFilter _activeFilter = _defaultFilter;

  @override
  ObjectiveFilter get activeFilter => _activeFilter;

  // LRUCache would make sense here for infinite pagination, not for standard pagination
  Paginable<WorkspaceTask>? _cachedTasks;

  @override
  Paginable<WorkspaceTask>? get tasks => _cachedTasks;

  @override
  Stream<Result<void>> loadTasks({
    required String workspaceId,
    bool forceFetch = false,
    ObjectiveFilter? filter,
  }) async* {
    // Either use provided filter or cached one
    final effectiveFilter = filter ?? _activeFilter;
    // This is merely used when there was an attempt to load
    // filtered tasks offline from the API to revert the filter
    final prevFilter = _activeFilter;
    final isChangingFilter = effectiveFilter != _activeFilter;

    if (!forceFetch &&
        effectiveFilter == _activeFilter &&
        _cachedTasks != null) {
      // Read from in-memory cache
      yield const Result.ok(null);
    }

    // We load from DB:
    // 1. on the initial load only
    // 2. if no filters were applied (this is maybe
    // redundant because of point 1.)
    if (!forceFetch &&
        _cachedTasks == null &&
        effectiveFilter == _defaultFilter) {
      final dbResult = await _databaseService.getTasks();
      if (dbResult is Ok<Paginable<WorkspaceTask>?>) {
        final dbTasks = dbResult.value;
        if (dbTasks != null) {
          _cachedTasks = dbTasks;
          _activeFilter = effectiveFilter;
          notifyListeners();
          yield const Result.ok(null);
        }
      }
    }

    if (effectiveFilter != _activeFilter) {
      _activeFilter = effectiveFilter;
    }
    _isFilterSearch = _activeFilter != _defaultFilter;

    // This is an edge case when user fetches e.g. All statuses
    // then goes to nth page, and then tries to fetch only
    // Completed status, but the result doesn't have that page
    // (it has less pages). So in this case we always revert to
    // page 1.
    if (filter != null &&
        (prevFilter.status != filter.status ||
            prevFilter.search != filter.search)) {
      _activeFilter = _activeFilter.copyWith(page: 1);
      _isFilterSearch = _activeFilter != _defaultFilter;
      notifyListeners();
    }

    // Trigger API request
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
        notifyListeners();

        await _updateDbCache(_cachedTasks!);

        yield const Result.ok(null);
      case Error<PaginableResponse<WorkspaceTaskResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.getTasks failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );

        if (isChangingFilter) {
          // Return to previous filter in case of an error
          _activeFilter = prevFilter;
          _isFilterSearch = _activeFilter != _defaultFilter;
          notifyListeners();
        }

        yield Result.error(result.error, result.stackTrace);
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
        _cachedTasks!.items.add(newTask);
        ++_cachedTasks!.total;
        _cachedTasks!.totalPages = (_cachedTasks!.total / _activeFilter.limit)
            .ceil();
        notifyListeners();

        // Update persistent cache
        await _updateDbCache(_cachedTasks!);

        return const Result.ok(null);
      case Error<WorkspaceTaskResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.createTask failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Result<WorkspaceTask> loadWorkspaceTaskDetails({required String taskId}) {
    final details = _cachedTasks?.items.firstWhereOrNull(
      (task) => task.id == taskId,
    );

    if (details == null) {
      return Result.error(Exception('Task $taskId not found'));
    }

    return Result.ok(details);
  }

  @override
  Future<Result<void>> updateTaskDetails(
    String workspaceId,
    String taskId, {
    ValuePatch<String>? title,
    ValuePatch<String?>? description,
    ValuePatch<int>? rewardPoints,
    ValuePatch<DateTime?>? dueDate,
  }) async {
    final result = await _workspaceTaskApiService.updateTaskDetails(
      workspaceId: workspaceId,
      taskId: taskId,
      payload: UpdateTaskDetailsRequest(
        title: title,
        description: description,
        rewardPoints: rewardPoints,
        dueDate: dueDate,
      ),
    );

    switch (result) {
      case Ok():
        final existingTaskResult =
            loadWorkspaceTaskDetails(taskId: taskId) as Ok<WorkspaceTask>;
        final existingTask = existingTaskResult.value;
        final updatedTask = _mapTaskFromResponse(
          result.value,
          isNew: existingTask.isNew,
        );

        final taskIndex = _cachedTasks!.items.indexWhere(
          (task) => task.id == updatedTask.id,
        );

        if (taskIndex != -1) {
          // Update the existing task in the list by replacing it
          // with the new updated instance.
          _cachedTasks!.items[taskIndex] = updatedTask;
          notifyListeners();

          // Update persistent cache
          await _updateDbCache(_cachedTasks!);
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.updateTaskDetails failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> addTaskAssignee(
    String workspaceId,
    String taskId,
    List<String> assigneeIds,
  ) async {
    final result = await _workspaceTaskApiService.addTaskAssignee(
      workspaceId: workspaceId,
      taskId: taskId,
      payload: AddTaskAssigneeRequest(assigneeIds: assigneeIds),
    );

    switch (result) {
      case Ok<List<AddTaskAssigneeResponse>>():
        final existingTaskResult =
            loadWorkspaceTaskDetails(taskId: taskId) as Ok<WorkspaceTask>;
        final existingTask = existingTaskResult.value;
        final taskIndex = _cachedTasks!.items.indexWhere(
          (task) => task.id == existingTask.id,
        );

        if (taskIndex != -1) {
          final newAssignees = result.value
              .map(
                (assignee) => WorkspaceTaskAssignee(
                  id: assignee.id,
                  firstName: assignee.firstName,
                  lastName: assignee.lastName,
                  profileImageUrl: assignee.profileImageUrl,
                  status: assignee.status,
                ),
              )
              .toList();

          // We need to add new assignee sorted because assignees are
          // sorted alphabetically by firstName and lastName
          final updatedAssignees = [...existingTask.assignees, ...newAssignees]
            ..sort(_assigneeCmp);
          final updatedTask = existingTask.copyWith(
            assignees: updatedAssignees,
          );
          _cachedTasks!.items[taskIndex] = updatedTask;
          notifyListeners();

          // Update persistent cache
          await _updateDbCache(_cachedTasks!);
        }

        return const Result.ok(null);
      case Error<List<AddTaskAssigneeResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.addTaskAssignee failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> removeTaskAssignee(
    String workspaceId,
    String taskId,
    String assigneeId,
  ) async {
    final existingTaskResult =
        loadWorkspaceTaskDetails(taskId: taskId) as Ok<WorkspaceTask>;

    if (existingTaskResult.value.assignees.length == 1) {
      // Guard case, the actual user's guard is done in the
      // uI with a modal blocking the removal of the last assignee
      return const Result.ok(null);
    }

    final result = await _workspaceTaskApiService.removeTaskAssignee(
      workspaceId: workspaceId,
      taskId: taskId,
      payload: RemoveTaskAssigneeRequest(assigneeId: assigneeId),
    );

    switch (result) {
      case Ok():
        final existingTaskResult =
            loadWorkspaceTaskDetails(taskId: taskId) as Ok<WorkspaceTask>;
        final existingTask = existingTaskResult.value;
        final taskIndex = _cachedTasks!.items.indexWhere(
          (task) => task.id == existingTask.id,
        );

        if (taskIndex != -1) {
          final newAssigneesList = existingTask.assignees
              .where((assignee) => assignee.id != assigneeId)
              .toList();

          final updatedTask = existingTask.copyWith(
            assignees: newAssigneesList,
          );
          _cachedTasks!.items[taskIndex] = updatedTask;
          notifyListeners();

          // Update persistent cache
          await _updateDbCache(_cachedTasks!);
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.removeTaskAssignee failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> updateTaskAssignments(
    String workspaceId,
    String taskId,
    List<(String assigneeId, ProgressStatus status)> assignments,
  ) async {
    final result = await _workspaceTaskApiService.updateTaskAssignments(
      workspaceId: workspaceId,
      taskId: taskId,
      payload: UpdateTaskAssignmentsRequest(
        assignments: assignments
            .map(
              (assignee) =>
                  Assignment(assigneeId: assignee.$1, status: assignee.$2),
            )
            .toList(),
      ),
    );

    switch (result) {
      case Ok<List<UpdateTaskAssignmentResponse>>():
        final existingTaskResult =
            loadWorkspaceTaskDetails(taskId: taskId) as Ok<WorkspaceTask>;
        final existingTask = existingTaskResult.value;
        final taskIndex = _cachedTasks!.items.indexWhere(
          (task) => task.id == existingTask.id,
        );

        if (taskIndex != -1) {
          // Update the existing task in the list by updating the needed assignments
          // creating new `WorkspaceTaskAssignee` instances and also creating new task instance.
          final newAssignees = existingTask.assignees.map((assignee) {
            final change = assignments.firstWhereOrNull(
              (c) => c.$1 == assignee.id,
            );

            // Check if the current assignee was updated
            if (change != null) {
              return assignee.copyWith(status: change.$2);
            } else {
              return assignee;
            }
          }).toList();
          final updatedTask = existingTask.copyWith(assignees: newAssignees);
          _cachedTasks!.items[taskIndex] = updatedTask;
          notifyListeners();

          // Update persistent cache
          await _updateDbCache(_cachedTasks!);
        }

        return const Result.ok(null);
      case Error<List<UpdateTaskAssignmentResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.updateTaskAssignments failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> closeTask({
    required String workspaceId,
    required String taskId,
  }) async {
    final result = await _workspaceTaskApiService.closeTask(
      workspaceId: workspaceId,
      taskId: taskId,
    );

    switch (result) {
      case Ok():
        final closedTask = _cachedTasks!.items.firstWhere(
          (task) => task.id == taskId,
        );
        _cachedTasks!.items.remove(closedTask);
        // Calculate total, totalPages and current page
        --_cachedTasks!.total;
        final newTotalPages = (_cachedTasks!.total / _activeFilter.limit)
            .ceil();
        _cachedTasks!.totalPages = newTotalPages;
        if (_cachedTasks!.items.isEmpty && _cachedTasks!.total > 0) {
          // Go to previous page if possible, or stay on the 1st
          final targetPage = _activeFilter.page > 1
              ? _activeFilter.page - 1
              : 1;
          _activeFilter = _activeFilter.copyWith(page: targetPage);
          notifyListeners();
          await loadTasks(workspaceId: workspaceId, forceFetch: true).last;
          return const Result.ok(null);
        }
        notifyListeners();

        // Update persistent cache
        await _updateDbCache(_cachedTasks!);

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceTaskApiService.closeTask failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<void> purgeTasksCache() async {
    _isFilterSearch = false;
    _cachedTasks = null;
    _activeFilter = _defaultFilter;
    await _databaseService.clearTasks();
  }

  Future<void> _updateDbCache(Paginable<WorkspaceTask> payload) async {
    // Save to DB only if filter is the same as
    // the default filter (first page with no filters)
    if (_isFilterSearch) {
      return;
    }

    final dbSaveResult = await _databaseService.setTasks(payload);
    if (dbSaveResult is Error<void>) {
      _loggerService.log(
        LogLevel.warn,
        'databaseService.setTasks failed',
        error: dbSaveResult.error,
      );
    }
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
      createdBy: task.createdBy == null
          ? null
          : CreatedBy(
              id: task.createdBy!.id,
              firstName: task.createdBy!.firstName,
              lastName: task.createdBy!.lastName,
              profileImageUrl: task.createdBy!.profileImageUrl,
            ),
      description: task.description,
      dueDate: task.dueDate,
      isNew: isNew,
    );
  }

  int _assigneeCmp(WorkspaceTaskAssignee a, WorkspaceTaskAssignee b) {
    final aFirst = a.firstName.toLowerCase();
    final aLast = a.lastName.toLowerCase();
    final bFirst = b.firstName.toLowerCase();
    final bLast = b.lastName.toLowerCase();

    final byFirst = aFirst.compareTo(bFirst);
    if (byFirst != 0) {
      return byFirst;
    }

    final byLast = aLast.compareTo(bLast);
    if (byLast != 0) {
      return byLast;
    }

    // Stability - we never return 0 (equal)
    return a.id.compareTo(b.id);
  }
}
