import '../../data/services/api/user/models/response/user_response.dart';
import 'created_by.dart';
import 'interfaces/user_interface.dart';

class WorkspaceUser implements BaseUser {
  WorkspaceUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.userId,
    required this.createdAt,
    required this.email,
    required this.profileImageUrl,
    required this.createdBy,
  });

  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  final WorkspaceRole role;
  final String userId;
  final DateTime createdAt;
  @override
  final String? email;
  final String? profileImageUrl;
  final CreatedBy? createdBy;

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'role': role.value,
    'userId': userId,
    'createdAt': createdAt.toIso8601String(),
    'email': email,
    'profileImageUrl': profileImageUrl,
    'createdBy': createdBy?.toMap(),
  };

  factory WorkspaceUser.fromMap(Map<dynamic, dynamic> map) => WorkspaceUser(
    id: map['id'] as String,
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    role: WorkspaceRole.values.firstWhere(
      (e) => e.value == (map['role'] as String),
      orElse: () => WorkspaceRole.member,
    ),
    userId: map['userId'] as String,
    createdAt: DateTime.parse(map['createdAt'] as String),
    email: map['email'] as String?,
    profileImageUrl: map['profileImageUrl'] as String?,
    createdBy: map['createdBy'] == null
        ? null
        : CreatedBy.fromMap(
            Map<dynamic, dynamic>.from(map['createdBy'] as Map),
          ),
  );
}
