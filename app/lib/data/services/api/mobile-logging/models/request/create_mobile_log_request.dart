import 'package:json_annotation/json_annotation.dart';

import '../../../../../../logger/logger_interface.dart';

part 'create_mobile_log_request.g.dart';

@JsonSerializable(createFactory: false)
class CreateMobileLogRequest {
  CreateMobileLogRequest({
    required this.userId,
    required this.level,
    required this.message,
    this.stackTrace,
    this.context,
  });

  final String? userId;
  final LogLevel level;
  final String message;
  @JsonKey(includeIfNull: false)
  final String? stackTrace;
  @JsonKey(includeIfNull: false)
  final String? context;

  Map<String, dynamic> toJson() => _$CreateMobileLogRequestToJson(this);
}
