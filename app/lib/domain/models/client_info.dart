class ClientInfo {
  const ClientInfo({
    required this.appVersion,
    this.deviceModel,
    this.osVersion,
  });

  final String appVersion;
  final String? deviceModel;
  final String? osVersion;
}
