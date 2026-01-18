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

  bool _initialized = false;

  /// We init client info once on app startup because these
  /// read operations are a bit expensive.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

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

    _initialized = true;
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
    if (!_initialized) {
      throw StateError('ClientInfoService not initialized.');
    }
  }
}
