import 'package:logging/logging.dart';

import '../../../../domain/models/assignee.dart';
import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/filter.dart';
import '../../../../domain/models/paginable.dart';
import '../../../../domain/models/workspace_goal.dart';
import '../../../../utils/command.dart';
import '../../../services/api/paginable.dart';
import '../../../services/api/value_patch.dart';
import '../../../services/api/workspace/paginable_objectives.dart';
import '../../../services/api/workspace/progress_status.dart';
import '../../../services/api/workspace/workspace_goal/models/request/create_goal_request.dart';
import '../../../services/api/workspace/workspace_goal/models/request/update_goal_details_request.dart';
import '../../../services/api/workspace/workspace_goal/models/response/workspace_goal_response.dart';
import '../../../services/api/workspace/workspace_goal/workspace_goal_api_service.dart';
import 'workspace_goal_repository.dart';

const _kDefaultPaginablePage = 1;
const _kDefaultPaginableLimit = 15;
const _kDefaultPaginableSort = SortBy.newestFirst;
const _kDefaultPaginableStatus = ProgressStatus.inProgress;

class WorkspaceGoalRepositoryImpl extends WorkspaceGoalRepository {
  WorkspaceGoalRepositoryImpl({
    required WorkspaceGoalApiService workspaceGoalApiService,
  }) : _workspaceGoalApiService = workspaceGoalApiService;

  final WorkspaceGoalApiService _workspaceGoalApiService;

  final _log = Logger('WorkspaceGoalRepository');

  bool _isFilterSearch = false;

  @override
  bool get isFilterSearch => _isFilterSearch;

  ObjectiveFilter _activeFilter = ObjectiveFilter(
    page: _kDefaultPaginablePage,
    limit: _kDefaultPaginableLimit,
    sort: _kDefaultPaginableSort,
    status: _kDefaultPaginableStatus,
  );

  @override
  ObjectiveFilter get activeFilter => _activeFilter;

  // LRUCache would make sense here for infinite pagination, not for standard pagination
  Paginable<WorkspaceGoal>? _cachedGoals;

  @override
  Paginable<WorkspaceGoal>? get goals => _cachedGoals;

  @override
  Future<Result<void>> loadGoals({
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
        _cachedGoals != null) {
      return const Result.ok(null);
    }

    if (effectiveFilter != _activeFilter) {
      _activeFilter = effectiveFilter;
      _isFilterSearch = true;
    }

    if (filter == null) {
      _isFilterSearch = false;
    }

    try {
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

          return const Result.ok(null);
        case Error<PaginableResponse<WorkspaceGoalResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
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
    try {
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
          notifyListeners();

          return const Result.ok(null);
        case Error<WorkspaceGoalResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Result<WorkspaceGoal> loadGoalDetails({required String goalId}) {
    final details = _cachedGoals!.items.firstWhere((goal) => goal.id == goalId);
    return Result.ok(details);
  }

  @override
  Future<Result<void>> updateGoalDetails(
    String workspaceId,
    String goalId, {
    ValuePatch<String>? title,
    ValuePatch<String?>? description,
    ValuePatch<String?>? assigneeId,
    ValuePatch<int>? requiredPoints,
  }) async {
    try {
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
          }

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> closeGoal({
    required String workspaceId,
    required String goalId,
  }) async {
    try {
      final result = await _workspaceGoalApiService.closeGoal(
        workspaceId: workspaceId,
        goalId: goalId,
      );

      switch (result) {
        case Ok():
          final goalIndex = _cachedGoals!.items.indexWhere(
            (goal) => goal.id == goalId,
          );

          if (goalIndex != -1) {
            final existingGoalResult =
                loadGoalDetails(goalId: goalId) as Ok<WorkspaceGoal>;
            final existingGoal = existingGoalResult.value;
            final updatedGoal = existingGoal.copyWith(
              status: ProgressStatus.closed,
            );
            _cachedGoals!.items[goalIndex] = updatedGoal;
            notifyListeners();
          }

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  void purgeGoalsCache() {
    _cachedGoals = null;
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
