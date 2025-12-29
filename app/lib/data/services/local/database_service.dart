import 'package:hive_flutter/hive_flutter.dart';

import '../../../domain/models/user.dart';
import '../../../domain/models/workspace.dart';
import '../../../utils/command.dart';

// We will use one box for all data caches
const hiveBoxName = 'cache';

class DatabaseService {
  static late final Box _box;

  static const String _currentUserKey = 'user';
  static const String _workspacesKey = 'workspaces';

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
        await _box.delete(_workspacesKey);
        return const Result.ok([]);
      }

      final list = raw
          .map((e) => Workspace.fromMap(Map<dynamic, dynamic>.from(e as Map)))
          .toList();

      return Result.ok(list);
    } on Exception catch (error, stackTrace) {
      // Cache is probably not compatible/corrupt -> clean it
      clearWorkspaces();
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

  static Future<Result<void>> clear() async {
    try {
      await _box.clear();
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
