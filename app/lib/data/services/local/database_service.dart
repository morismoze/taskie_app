import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/paginable.dart';
import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/models/workspace_goal.dart';
import '../../../domain/models/workspace_leaderboard_user.dart';
import '../../../domain/models/workspace_task.dart';
import '../../../domain/models/workspace_user.dart';
import '../../../utils/command.dart';

// We will use one box for all data caches
const hiveBoxName = 'cache';

class DatabaseService {
  static late final Box _box;

  static const String _currentUserKey = 'user';
  static const String _workspacesKey = 'workspaces';
  static const String _leaderboardKey = 'leaderboard';
  static const String _goalsKey = 'goals';
  static const String _tasksKey = 'tasks';
  static const String _workspaceUsersKey = 'workspaceUsers';

  Future<Result<User?>> getUser() async {
    try {
      final raw = _box.get(_currentUserKey);

      if (raw == null) {
        return const Result.ok(null);
      }

      final user = User.fromMap(Map<dynamic, dynamic>.from(raw as Map));
      return Result.ok(user);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      clearUser();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setUser(User user) async {
    try {
      await _box.put(_currentUserKey, user.toMap());
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearUser() async {
    try {
      await _box.delete(_currentUserKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<List<Workspace>>> getWorkspaces() async {
    try {
      final raw = _box.get(_workspacesKey);
      if (raw == null) {
        return const Result.ok([]);
      }

      if (raw is! List) {
        await clearWorkspaces();
        return const Result.ok([]);
      }

      final list = raw
          .map((e) => Workspace.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList();

      return Result.ok(list);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      await clearWorkspaces();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setWorkspaces(List<Workspace> workspaces) async {
    try {
      final payload = workspaces.map((w) => w.toMap()).toList();
      await _box.put(_workspacesKey, payload);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearWorkspaces() async {
    try {
      await _box.delete(_workspacesKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<List<WorkspaceLeaderboardUser>>> getLeaderboard() async {
    try {
      final raw = _box.get(_leaderboardKey);
      if (raw == null) {
        return const Result.ok([]);
      }

      if (raw is! List) {
        await clearLeaderboard();
        return const Result.ok([]);
      }

      final list = raw
          .map(
            (e) => WorkspaceLeaderboardUser.fromMap(
              Map<dynamic, dynamic>.from(e as Map),
            ),
          )
          .toList();

      return Result.ok(list);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      await clearLeaderboard();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setLeaderboard(
    List<WorkspaceLeaderboardUser> leaderboard,
  ) async {
    try {
      final payload = leaderboard.map((lu) => lu.toMap()).toList();
      await _box.put(_leaderboardKey, payload);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearLeaderboard() async {
    try {
      await _box.delete(_leaderboardKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<Paginable<WorkspaceGoal>?>> getGoals() async {
    try {
      final raw = _box.get(_goalsKey);
      if (raw == null) {
        return const Result.ok(null);
      }

      if (raw is! Map) {
        await clearGoals();
        return const Result.ok(null);
      }

      final goals = Paginable<WorkspaceGoal>.fromMap(
        Map<dynamic, dynamic>.from(raw),
        fromItemMap: (m) => WorkspaceGoal.fromMap(m),
      );

      return Result.ok(goals);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      await clearGoals();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setGoals(Paginable<WorkspaceGoal> goals) async {
    try {
      final payload = goals.toMap((g) => g.toMap());
      await _box.put(_goalsKey, payload);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearGoals() async {
    try {
      await _box.delete(_goalsKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<Paginable<WorkspaceTask>?>> getTasks() async {
    try {
      final raw = _box.get(_tasksKey);
      if (raw == null) {
        return const Result.ok(null);
      }

      if (raw is! Map) {
        await clearTasks();
        return const Result.ok(null);
      }

      final tasks = Paginable<WorkspaceTask>.fromMap(
        Map<dynamic, dynamic>.from(raw),
        fromItemMap: (m) => WorkspaceTask.fromMap(m),
      );

      return Result.ok(tasks);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      await clearTasks();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setTasks(Paginable<WorkspaceTask> tasks) async {
    try {
      final payload = tasks.toMap((g) => g.toMap());
      await _box.put(_tasksKey, payload);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearTasks() async {
    try {
      await _box.delete(_tasksKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<List<WorkspaceUser>>> getWorkspaceUsers() async {
    try {
      final raw = _box.get(_workspaceUsersKey);
      if (raw == null) {
        return const Result.ok([]);
      }

      if (raw is! List) {
        await clearWorkspaceUsers();
        return const Result.ok([]);
      }

      final list = raw
          .map(
            (e) => WorkspaceUser.fromMap(Map<dynamic, dynamic>.from(e as Map)),
          )
          .toList();

      return Result.ok(list);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      await clearWorkspaceUsers();
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> setWorkspaceUsers(List<WorkspaceUser> workspaces) async {
    try {
      final payload = workspaces.map((w) => w.toMap()).toList();
      await _box.put(_workspaceUsersKey, payload);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  Future<Result<void>> clearWorkspaceUsers() async {
    try {
      await _box.delete(_workspaceUsersKey);
      return const Result.ok(null);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox(hiveBoxName);
  }
}
