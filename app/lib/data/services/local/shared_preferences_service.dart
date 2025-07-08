import 'package:logging/logging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/command.dart';

class SharedPreferencesService {
  final SharedPreferencesAsync _sharedPreferencesAsync =
      SharedPreferencesAsync();

  static const _activeWorkspaceKey = "ACTIVE_WORKSPACE";
  final _log = Logger("SharedPreferencesService");

  Future<Result<String?>> getActiveWorkspaceId() async {
    try {
      return Result.ok(
        await _sharedPreferencesAsync.getString(_activeWorkspaceKey),
      );
    } on Exception catch (e) {
      _log.warning("Failed to get active workspace ID", e);
      return Result.error(e);
    }
  }

  Future<Result<void>> setActiveWorkspaceId({
    required String workspaceId,
  }) async {
    try {
      await _sharedPreferencesAsync.setString(_activeWorkspaceKey, workspaceId);
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning("Failed to get active workspace ID", e);
      return Result.error(e);
    }
  }
}
