// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ApiResponse<T> _$ApiResponseFromJson<T>(
  Map<String, dynamic> json,
  T Function(Object? json) fromJsonT,
) => ApiResponse<T>(
  data: _$nullableGenericFromJson(json['data'], fromJsonT),
  error: json['error'] == null
      ? null
      : ApiError.fromJson(json['error'] as Map<String, dynamic>),
);

T? _$nullableGenericFromJson<T>(
  Object? input,
  T Function(Object? json) fromJson,
) => input == null ? null : fromJson(input);

ApiError _$ApiErrorFromJson(Map<String, dynamic> json) => ApiError(
  code: $enumDecode(_$ApiErrorCodeEnumMap, json['code']),
  context: json['context'] as String?,
);

const _$ApiErrorCodeEnumMap = {
  ApiErrorCode.serverError: '0',
  ApiErrorCode.invalidPayload: '1',
  ApiErrorCode.emailAlreadyExists: '2',
  ApiErrorCode.workspaceInviteAlreadyUsed: '3',
  ApiErrorCode.workspaceInviteExpired: '4',
  ApiErrorCode.workspaceInviteExistingUser: '5',
  ApiErrorCode.notFoundWorkspaceInviteToken: '6',
  ApiErrorCode.taskClosed: '7',
};
