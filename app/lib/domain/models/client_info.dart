class ClientInfo {
  const ClientInfo({
    required this.appId,
    required this.appName,
    required this.appVersion,
    required this.buildNumber,
    this.deviceModel,
    this.osVersion,
  });

  final String appId;
  final String appName;
  final String appVersion;
  final String buildNumber;
  final String? deviceModel;
  final String? osVersion;
}
