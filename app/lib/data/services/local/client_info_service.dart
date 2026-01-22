import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../domain/models/client_info.dart';
import '../../../utils/command.dart';

class ClientInfoService {
  ClientInfoService();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  // On first app start ever, flutter intl could change the language
  // by checking system language (e.g. Updating configuration, locales updated
  // from [en] to [hr_HR]). This could trigger init function once again so
  // we introduce checking if the current initFuture was alrady triggered.
  // Checking a simple bool flag is not enough because bool is set only
  // when the whole init logic is finished, and in that time interval
  // another call to init function could have been made.
  Future<Result<ClientInfo>>? _initFuture;

  /// We init client info once on app startup because these
  /// read operations are a bit expensive.
  Future<Result<ClientInfo>> init() async {
    _initFuture ??= _initLogic();
    return _initFuture!;
  }

  /// We init client info once on app startup because these
  /// read operations are a bit expensive.
  Future<Result<ClientInfo>> _initLogic() async {
    try {
      final pkg = await PackageInfo.fromPlatform();

      String? deviceModel;
      String? osVersion;

      if (Platform.isAndroid) {
        final a = await _deviceInfo.androidInfo;
        deviceModel = a.model;
        osVersion = a.version.release;
      } else if (Platform.isIOS) {
        final i = await _deviceInfo.iosInfo;
        deviceModel = i.utsname.machine;
        osVersion = i.systemVersion;
      } else {
        deviceModel = null;
        osVersion = Platform.operatingSystemVersion;
      }

      return Result.ok(
        ClientInfo(
          appName: pkg.appName,
          appVersion: pkg.version,
          buildNumber: pkg.buildNumber,
          deviceModel: deviceModel,
          osVersion: osVersion,
        ),
      );
    } on Exception catch (e, stackTrace) {
      return Result.error(e, stackTrace);
    }
  }
}
