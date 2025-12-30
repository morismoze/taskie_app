import 'package:flutter/material.dart';

import '../../../data/repositories/preferences/preferences_repository.dart';
import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace_goal/workspace_goal_repository.dart';
import '../../../domain/models/filter.dart';
import '../../../domain/models/paginable.dart';
import '../../../domain/models/workspace_goal.dart';
import '../../../utils/command.dart';

class GoalsScreenViewmodel extends ChangeNotifier {
  GoalsScreenViewmodel({
    required String workspaceId,
    required UserRepository userRepository,
    required WorkspaceGoalRepository workspaceGoalRepository,
    required PreferencesRepository preferencesRepository,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceGoalRepository = workspaceGoalRepository,
       _preferencesRepository = preferencesRepository {
    _workspaceGoalRepository.addListener(_onGoalsChanged);
    // Repository defines default values for ObjectiveFilter, so we use null here for it
    loadGoals = Command1(_loadGoals)..execute((null, null));
  }

  final String _activeWorkspaceId;
  final WorkspaceGoalRepository _workspaceGoalRepository;
  final PreferencesRepository _preferencesRepository;

  late Command1<void, (ObjectiveFilter? filter, bool? forceFetch)> loadGoals;

  String get activeWorkspaceId => _activeWorkspaceId;

  /// [appLocale] in [PreferencesRepository] is set up in AppStartup.
  Locale get appLocale => _preferencesRepository.appLocale!;

  bool get isFilterSearch => _workspaceGoalRepository.isFilterSearch;

  ObjectiveFilter get activeFilter => _workspaceGoalRepository.activeFilter;

  Paginable<WorkspaceGoal>? get goals {
    final goals = _workspaceGoalRepository.goals;

    if (goals == null) {
      return null;
    }

    final clonedGoals = Paginable.clone(goals);
    // Sort goals so that goals with `isNew` property set
    // to true are always at the top
    clonedGoals.items.sort((g1, g2) {
      // Checking `!g2.isNew` for stable sorting
      if (g1.isNew && !g2.isNew) {
        return -1;
      }

      if (g2.isNew && !g1.isNew) {
        // Checking `!g1.isNew` for stable sorting
        return 1;
      }

      // New goals should be additionally sorted by creation
      // date so that newest created ones are first (DESC)
      if (g1.isNew && g2.isNew) {
        return g2.createdAt.compareTo(g1.createdAt);
      }

      // If both goals are not new, keep the original ordering
      if (!g1.isNew && !g2.isNew) {
        return 0;
      }

      // Safety case - keep the original ordering
      return 0;
    });

    return clonedGoals;
  }

  void _onGoalsChanged() {
    // Forward the change notification from repository to the viewmodel
    notifyListeners();
  }

  Future<Result<void>> _loadGoals(
    (ObjectiveFilter? filter, bool? forceFetch) details,
  ) async {
    final (filter, forceFetch) = details;
    final result = await firstOkOrLastError(
      _workspaceGoalRepository.loadGoals(
        workspaceId: _activeWorkspaceId,
        filter: filter,
        forceFetch: forceFetch ?? false,
      ),
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }

  @override
  void dispose() {
    _workspaceGoalRepository.removeListener(_onGoalsChanged);
    super.dispose();
  }
}
