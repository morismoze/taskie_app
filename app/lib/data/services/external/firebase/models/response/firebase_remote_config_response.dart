import 'package:json_annotation/json_annotation.dart';

part 'firebase_remote_config_response.g.dart';

@JsonSerializable(createToJson: false)
class FirebaseRemoteConfigResponse {
  FirebaseRemoteConfigResponse({required this.versionControl});

  @JsonKey(name: 'version_control')
  final VersionControl versionControl;

  factory FirebaseRemoteConfigResponse.fromJson(Map<String, dynamic> json) =>
      _$FirebaseRemoteConfigResponseFromJson(json);
}

@JsonSerializable(createToJson: false)
class VersionControl {
  VersionControl({required this.latestVersion});

  @JsonKey(name: 'latest_version')
  final String latestVersion;

  factory VersionControl.fromJson(Map<String, dynamic> json) =>
      _$VersionControlFromJson(json);
}
