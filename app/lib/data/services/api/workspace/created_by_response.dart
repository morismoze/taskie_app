import 'package:json_annotation/json_annotation.dart';

part 'created_by_response.g.dart';

@JsonSerializable(createToJson: false)
class CreatedByResponse {
  CreatedByResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  factory CreatedByResponse.fromJson(Map<String, dynamic> json) =>
      _$CreatedByResponseFromJson(json);
}
