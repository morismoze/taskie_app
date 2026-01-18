import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart';

class ClientInfoService {
  ClientInfoService();

  final DeviceInfoPlugin _deviceInfo = DeviceInfoPlugin();

  late final String _appName;
  late final String _appVersion;
  late final String _buildNumber;
  late final String? _deviceModel;
  late final String? _osVersion;

  // On first app start ever, flutter intl could change the language
  // by checking system language (e.g. Updating configuration, locales updated
  // from [en] to [hr_HR]). This could trigger init function once again so
  // we introduce checking if the current initFuture was alrady triggered.
  // Checking a simple bool flag is not enough because bool is set only
  // when the whole init logic is finished, and in that time interval
  // another call to init function could have been made.
  Future<void>? _initFuture;

  /// We init client info once on app startup because these
  /// read operations are a bit expensive.
  Future<void> init() async {
    _initFuture ??= initLogic();
    return _initFuture!;
  }

  /// We init client info once on app startup because these
  /// read operations are a bit expensive.
  Future<void> initLogic() async {
    final pkg = await PackageInfo.fromPlatform();

    _appName = pkg.appName;
    _appVersion = pkg.version;
    _buildNumber = pkg.buildNumber;
    if (Platform.isAndroid) {
      final a = await _deviceInfo.androidInfo;
      _deviceModel = a.model;
      _osVersion = a.version.release;
    } else if (Platform.isIOS) {
      final i = await _deviceInfo.iosInfo;
      _deviceModel = i.utsname.machine;
      _osVersion = i.systemVersion;
    } else {
      _deviceModel = null;
      _osVersion = Platform.operatingSystemVersion;
    }
  }

  String get appName {
    _ensureInit();
    return _appName;
  }

  String get appVersion {
    _ensureInit();
    return _appVersion;
  }

  String get buildNumber {
    _ensureInit();
    return _buildNumber;
  }

  String? get deviceModel {
    _ensureInit();
    return _deviceModel;
  }

  String? get osVersion {
    _ensureInit();
    return _osVersion;
  }

  void _ensureInit() {
    if (_initFuture == null) {
      throw StateError('ClientInfoService not initialized.');
    }
  }
}
