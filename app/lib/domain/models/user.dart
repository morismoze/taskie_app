import '../../data/services/api/user/models/response/user_response.dart';

class User {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.roles,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final DateTime createdAt;
  final List<RolePerWorkspace> roles;
  // Email can be null in case of virtual users
  final String? email;
  // Profile image URL can be null in case of virtual users
  final String? profileImageUrl;
}
