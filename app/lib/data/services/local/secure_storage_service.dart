import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../../utils/command.dart';

class SecureStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();
  static const _accessTokenKey = "ACCESS_TOKEN";
  static const _refreshTokenKey = "REFRESH_TOKEN";

  Future<Result<String?>> getAccessToken() async {
    try {
      return Result.ok(await _storage.read(key: _accessTokenKey));
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> setAccessToken(String? token) async {
    try {
      await _storage.write(key: _accessTokenKey, value: token);
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<String?>> getRefreshToken() async {
    try {
      return Result.ok(await _storage.read(key: _refreshTokenKey));
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> setRefreshToken(String? token) async {
    try {
      await _storage.write(key: _refreshTokenKey, value: token);
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }

  Future<Result<void>> clearTokens() async {
    try {
      await _storage.delete(key: _accessTokenKey);
      await _storage.delete(key: _refreshTokenKey);
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }
}
