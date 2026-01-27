import 'dart:convert';

import 'package:firebase_remote_config/firebase_remote_config.dart';

import '../../../../utils/command.dart';
import 'models/response/firebase_remote_config_response.dart';

class RemoteConfigService {
  final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static const _appConfigKey = 'app_config';

  Future<Result<FirebaseRemoteConfigResponse>> fetchConfig() async {
    try {
      await _remoteConfig.setConfigSettings(
        RemoteConfigSettings(
          fetchTimeout: const Duration(seconds: 10),
          minimumFetchInterval: const Duration(hours: 12),
        ),
      );

      await _remoteConfig.fetchAndActivate();

      final rawJson = _remoteConfig.getString(_appConfigKey);

      if (rawJson.isEmpty) {
        return Result.error(
          Exception("Remote Config key '$_appConfigKey' is empty"),
        );
      }

      final Map<String, dynamic> decoded = jsonDecode(rawJson);
      final response = FirebaseRemoteConfigResponse.fromJson(decoded);

      return Result.ok(response);
    } on Exception catch (error, stackTrace) {
      return Result.error(error, stackTrace);
    }
  }
}
