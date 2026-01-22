import '../../data/services/api/user/models/response/user_response.dart';
import 'interfaces/user_interface.dart';

class User implements BaseUser {
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.createdAt,
    required this.roles,
    required this.email,
    required this.profileImageUrl,
  });

  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  final DateTime createdAt;
  final List<RolePerWorkspace> roles;

  /// Email can be null in case of virtual users
  @override
  final String? email;

  /// Profile image URL can be null in case of virtual users
  final String? profileImageUrl;

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'createdAt': createdAt.toIso8601String(),
    'roles': roles.map((role) => role.toMap()).toList(),
    'email': email,
    'profileImageUrl': profileImageUrl,
  };

  factory User.fromMap(Map<dynamic, dynamic> map) => User(
    id: map['id'] as String,
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    roles: (map['roles'] as List)
        .map(
          (e) => RolePerWorkspace.fromJson(Map<String, dynamic>.from(e as Map)),
        )
        .toList(),
    email: map['email'] as String?,
    profileImageUrl: map['profileImageUrl'] as String?,
  );
}
