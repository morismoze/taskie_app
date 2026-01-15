import 'package:json_annotation/json_annotation.dart';

part 'assignee_response.g.dart';

@JsonSerializable(createToJson: false)
class AssigneeResponse {
  AssigneeResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  factory AssigneeResponse.fromJson(Map<String, dynamic> json) =>
      _$AssigneeResponseFromJson(json);
}
