import 'package:collection/collection.dart';

import '../../../../domain/models/assignee.dart';
import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_goal.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/value_patch.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/workspace_goal/models/request/create_goal_request.dart';
import '../../../services/api/workspace/workspace_goal/models/request/update_goal_details_request.dart';
import '../../../services/api/workspace/workspace_goal/models/response/workspace_goal_response.dart';
import '../../../services/api/workspace/workspace_goal/workspace_goal_api_service.dart';
import '../../../services/local/database_service.dart';
import '../../../services/local/logger_service.dart';
import 'workspace_goal_repository.dart';

final _defaultFilter = ObjectiveFilter(
  page: 1,
  limit: 15,
  sort: SortBy.newestFirst,
);

class WorkspaceGoalRepositoryImpl extends WorkspaceGoalRepository {
  WorkspaceGoalRepositoryImpl({
    required WorkspaceGoalApiService workspaceGoalApiService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _workspaceGoalApiService = workspaceGoalApiService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final WorkspaceGoalApiService _workspaceGoalApiService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  bool _isFilterSearch = false;

  @override
  bool get isFilterSearch => _isFilterSearch;

  ObjectiveFilter _activeFilter = _defaultFilter;

  @override
  ObjectiveFilter get activeFilter => _activeFilter;

  // LRUCache would make sense here for infinite pagination, not for standard pagination
  Paginable<WorkspaceGoal>? _cachedGoals;

  @override
  Paginable<WorkspaceGoal>? get goals => _cachedGoals;

  @override
  Stream<Result<void>> loadGoals({
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
        _cachedGoals != null) {
      // Read from in-memory cache
      yield const Result.ok(null);
    }

    // We load from DB:
    // 1. on the initial load only
    // 2. if no filters were applied (this is maybe
    // redundant because of point 1.)
    if (!forceFetch &&
        _cachedGoals == null &&
        effectiveFilter == _defaultFilter) {
      final dbResult = await _databaseService.getGoals();
      if (dbResult is Ok<Paginable<WorkspaceGoal>?>) {
        final dbGoals = dbResult.value;
        if (dbGoals != null) {
          _cachedGoals = dbGoals;
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
    final result = await _workspaceGoalApiService.getGoals(
      workspaceId: workspaceId,
      queryParams: queryParams,
    );
    switch (result) {
      case Ok<PaginableResponse<WorkspaceGoalResponse>>():
        final items = result.value.items;
        final totalPages = result.value.totalPages;
        final total = result.value.total;
        final mappedData = items
            .map((goal) => _mapGoalFromResponse(goal))
            .toList();
        final paginable = Paginable(
          items: mappedData,
          totalPages: totalPages,
          total: total,
        );

        _cachedGoals = paginable;
        notifyListeners();

        // Update persistent cache
        await _updateDbCache(_cachedGoals!);

        yield const Result.ok(null);
      case Error<PaginableResponse<WorkspaceGoalResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceGoalApiService.getGoals failed',
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
  Future<Result<void>> createGoal(
    String workspaceId, {
    required String title,
    required String assignee,
    required int requiredPoints,
    String? description,
  }) async {
    final payload = CreateGoalRequest(
      title: title,
      assignee: assignee,
      requiredPoints: requiredPoints,
      description: description,
    );
    final result = await _workspaceGoalApiService.createGoal(
      workspaceId: workspaceId,
      payload: payload,
    );

    switch (result) {
      case Ok<WorkspaceGoalResponse>():
        // Add the new goal with the `isNew` flag, so additional
        // UI styles are applied to it in the current goals paginable page.
        // Also it is added to the current active filter key.
        final newGoal = _mapGoalFromResponse(result.value, isNew: true);

        // [_cachedGoals] should always be != null at this point in time, because
        // we show a error prompt with retry on the GoalsScreen if there was a problem
        // with initial goals load from origin.
        _cachedGoals!.items.add(newGoal);
        ++_cachedGoals!.total;
        // Re-calculate total pages
        _cachedGoals!.totalPages = (_cachedGoals!.total / _activeFilter.limit)
            .ceil();
        notifyListeners();

        // Update persistent cache
        await _updateDbCache(_cachedGoals!);

        return const Result.ok(null);
      case Error<WorkspaceGoalResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceGoalApiService.createGoal failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Result<WorkspaceGoal> loadGoalDetails({required String goalId}) {
    final details = _cachedGoals?.items.firstWhereOrNull(
      (goal) => goal.id == goalId,
    );

    if (details == null) {
      return Result.error(Exception('Goal $goalId not found'));
    }

    return Result.ok(details);
  }

  @override
  Future<Result<void>> updateGoalDetails(
    String workspaceId,
    String goalId, {
    ValuePatch<String>? title,
    ValuePatch<String?>? description,
    ValuePatch<String>? assigneeId,
    ValuePatch<int>? requiredPoints,
  }) async {
    final result = await _workspaceGoalApiService.updateGoalDetails(
      workspaceId: workspaceId,
      goalId: goalId,
      payload: UpdateGoalDetailsRequest(
        title: title,
        description: description,
        requiredPoints: requiredPoints,
        assigneeId: assigneeId,
      ),
    );

    switch (result) {
      case Ok():
        final existingGoalResult =
            loadGoalDetails(goalId: goalId) as Ok<WorkspaceGoal>;
        final existingGoal = existingGoalResult.value;
        final updatedGoal = _mapGoalFromResponse(
          result.value,
          isNew: existingGoal.isNew,
        );

        final goalIndex = _cachedGoals!.items.indexWhere(
          (goal) => goal.id == updatedGoal.id,
        );

        if (goalIndex != -1) {
          // Update the existing goal in the list by replacing it
          // with the new updated instance.
          _cachedGoals!.items[goalIndex] = updatedGoal;
          notifyListeners();

          // Update persistent cache
          await _updateDbCache(_cachedGoals!);
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceGoalApiService.updateGoalDetails failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> closeGoal({
    required String workspaceId,
    required String goalId,
  }) async {
    final result = await _workspaceGoalApiService.closeGoal(
      workspaceId: workspaceId,
      goalId: goalId,
    );

    switch (result) {
      case Ok():
        final closedGoal = _cachedGoals!.items.firstWhere(
          (goal) => goal.id == goalId,
        );
        _cachedGoals!.items.remove(closedGoal);
        // Calculate total, totalPages and current page
        --_cachedGoals!.total;
        final newTotalPages = (_cachedGoals!.total / _activeFilter.limit)
            .ceil();
        _cachedGoals!.totalPages = newTotalPages;
        if (_cachedGoals!.items.isEmpty && _cachedGoals!.total > 0) {
          // Go to previous page if possible, or stay on the 1st
          final targetPage = _activeFilter.page > 1
              ? _activeFilter.page - 1
              : 1;
          _activeFilter = _activeFilter.copyWith(page: targetPage);
          notifyListeners();
          await loadGoals(workspaceId: workspaceId, forceFetch: true).last;
          return const Result.ok(null);
        }
        notifyListeners();

        // Update persistent cache
        await _updateDbCache(_cachedGoals!);

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceGoalApiService.closeGoal failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<void> purgeGoalsCache() async {
    _isFilterSearch = false;
    _cachedGoals = null;
    _activeFilter = _defaultFilter;
    await _databaseService.clearGoals();
  }

  Future<void> _updateDbCache(Paginable<WorkspaceGoal> payload) async {
    // Save to DB only if filter is the same as
    // the default filter (first page with no filters)
    if (_isFilterSearch) {
      return;
    }

    final dbSaveResult = await _databaseService.setGoals(payload);
    if (dbSaveResult is Error<void>) {
      _loggerService.log(
        LogLevel.warn,
        'databaseService.setGoals failed',
        error: dbSaveResult.error,
      );
    }
  }

  WorkspaceGoal _mapGoalFromResponse(
    WorkspaceGoalResponse goal, {
    bool isNew = false,
  }) {
    return WorkspaceGoal(
      id: goal.id,
      title: goal.title,
      requiredPoints: goal.requiredPoints,
      accumulatedPoints: goal.accumulatedPoints,
      assignee: Assignee(
        id: goal.assignee.id,
        firstName: goal.assignee.firstName,
        lastName: goal.assignee.lastName,
        profileImageUrl: goal.assignee.profileImageUrl,
      ),
      createdAt: goal.createdAt,
      createdBy: goal.createdBy == null
          ? null
          : CreatedBy(
              id: goal.createdBy!.id,
              firstName: goal.createdBy!.firstName,
              lastName: goal.createdBy!.lastName,
              profileImageUrl: goal.createdBy!.profileImageUrl,
            ),
      status: goal.status,
      description: goal.description,
      isNew: isNew,
    );
  }
}
