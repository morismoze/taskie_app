// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'token_refresh_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TokenRefreshResponse _$TokenRefreshResponseFromJson(
  Map<String, dynamic> json,
) => TokenRefreshResponse(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenExpires: (json['tokenExpires'] as num).toInt(),
);

Map<String, dynamic> _$TokenRefreshResponseToJson(
  TokenRefreshResponse instance,
) => <String, dynamic>{
  'accessToken': instance.accessToken,
  'refreshToken': instance.refreshToken,
  'tokenExpires': instance.tokenExpires,
};
