import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logging/logging.dart';

import '../../../utils/command.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _accessTokenKey = "ACCESS_TOKEN";
  static const _refreshTokenKey = "REFRESH_TOKEN";
  final _log = Logger("SecureStorageService");

  Future<Result<String?>> getAccessToken() async {
    try {
      return Result.ok(await _storage.read(key: _accessTokenKey));
    } on Exception catch (e) {
      _log.warning("Failed to get access token", e);
      return Result.error(e);
    }
  }

  Future<Result<void>> setAccessToken(String? token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning("Failed to set access token", e);
      return Result.error(e);
    }
  }

  Future<Result<String?>> getRefreshToken() async {
    try {
      return Result.ok(await _storage.read(key: _refreshTokenKey));
    } on Exception catch (e) {
      _log.warning("Failed to get refresh token", e);
      return Result.error(e);
    }
  }

  Future<Result<void>> setRefreshToken(String? token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      return const Result.ok(null);
    } on Exception catch (e) {
      _log.warning("Failed to set refresh token", e);
      return Result.error(e);
    }
  }
}
