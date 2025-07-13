import 'package:json_annotation/json_annotation.dart';

import 'progress_status.dart';

part 'assignee_response.g.dart';

@JsonSerializable()
class AssigneeResponse {
  AssigneeResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final ProgressStatus status;
  final String? profileImageUrl;

  factory AssigneeResponse.fromJson(Map<String, dynamic> json) =>
      _$AssigneeResponseFromJson(json);
}
