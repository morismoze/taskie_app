import 'package:json_annotation/json_annotation.dart';

part 'user_response.g.dart';

@JsonSerializable()
class UserResponse {
  UserResponse({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String createdAt;
  final String? email;
  final String? profileImageUrl;

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);
}
