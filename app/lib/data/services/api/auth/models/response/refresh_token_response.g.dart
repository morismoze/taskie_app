// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'refresh_token_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RefreshTokenResponse _$RefreshTokenResponseFromJson(
  Map<String, dynamic> json,
) => RefreshTokenResponse(
  accessToken: json['accessToken'] as String,
  refreshToken: json['refreshToken'] as String,
  tokenExpires: (json['tokenExpires'] as num).toInt(),
);
