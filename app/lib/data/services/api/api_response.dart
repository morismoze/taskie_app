import 'package:json_annotation/json_annotation.dart';

part 'api_response.g.dart';

@JsonSerializable(genericArgumentFactories: true, createToJson: false)
class ApiResponse<T> {
  ApiResponse({this.data, this.error});

  final T? data;
  final ApiError? error;

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) => _$ApiResponseFromJson(json, fromJsonT);
}

@JsonSerializable(createToJson: false)
class ApiError {
  ApiError({required this.code, this.context});

  final ApiErrorCode code;
  final String? context;

  factory ApiError.fromJson(Map<String, dynamic> json) =>
      _$ApiErrorFromJson(json);
}

enum ApiErrorCode {
  @JsonValue('0')
  serverError(0),

  @JsonValue('1')
  invalidPayload(1),

  @JsonValue('2')
  emailAlreadyExists(2),

  @JsonValue('3')
  workspaceInviteAlreadyUsed(3),

  @JsonValue('4')
  workspaceInviteExpired(4),

  @JsonValue('5')
  workspaceInviteExistingUser(5),

  @JsonValue('6')
  notFoundWorkspaceInviteToken(6),

  @JsonValue('7')
  taskClosed(7),

  @JsonValue('8')
  taskAssigneesCountMaxedOut(8),

  @JsonValue('9')
  taskAssigneesInvalid(9),

  @JsonValue('10')
  taskAssigneesAlreadyExist(10);

  const ApiErrorCode(this.code);

  final int code;
}
