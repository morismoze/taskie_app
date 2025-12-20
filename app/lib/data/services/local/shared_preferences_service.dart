import 'package:shared_preferences/shared_preferences.dart';

import '../../../utils/command.dart';

class SharedPreferencesService {
  final SharedPreferencesAsync _sharedPreferencesAsync =
      SharedPreferencesAsync();

  static const _activeWorkspaceKey = "ACTIVE_WORKSPACE";
  static const _appLanguageCodeKey = "LANGUAGE_CODE";

  Future<Result<String?>> getActiveWorkspaceId() async {
    try {
      return Result.ok(
        await _sharedPreferencesAsync.getString(_activeWorkspaceKey),
      );
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> setActiveWorkspaceId({
    required String workspaceId,
  }) async {
    try {
      await _sharedPreferencesAsync.setString(_activeWorkspaceKey, workspaceId);
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<String?>> getAppLanguageCode() async {
    try {
      return Result.ok(
        await _sharedPreferencesAsync.getString(_appLanguageCodeKey),
      );
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> setAppLanguageCode({
    required String languageCode,
  }) async {
    try {
      await _sharedPreferencesAsync.setString(
        _appLanguageCodeKey,
        languageCode,
      );
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }
}
