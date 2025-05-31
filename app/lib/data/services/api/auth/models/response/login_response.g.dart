// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'login_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LoginResponse _$LoginResponseFromJson(Map<String, dynamic> json) =>
    LoginResponse(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
      tokenExpires: (json['tokenExpires'] as num).toInt(),
      user: LoginResponseUser.fromJson(json['user'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$LoginResponseToJson(LoginResponse instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'refreshToken': instance.refreshToken,
      'tokenExpires': instance.tokenExpires,
      'user': instance.user,
    };

LoginResponseUser _$LoginResponseUserFromJson(Map<String, dynamic> json) =>
    LoginResponseUser(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      createdAt: json['createdAt'] as String,
      email: json['email'] as String?,
      profileImageUrl: json['profileImageUrl'] as String?,
    );

Map<String, dynamic> _$LoginResponseUserToJson(LoginResponseUser instance) =>
    <String, dynamic>{
      'id': instance.id,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'createdAt': instance.createdAt,
      'email': instance.email,
      'profileImageUrl': instance.profileImageUrl,
    };
