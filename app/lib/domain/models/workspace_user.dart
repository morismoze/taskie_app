import '../../data/services/api/user/models/response/user_response.dart';

class WorkspaceUser {
  WorkspaceUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    required this.userId,
    required this.createdAt,
    this.email,
    this.profileImageUrl,
    this.createdBy,
  });

  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String userId;
  final DateTime createdAt;
  final String? email;
  final String? profileImageUrl;
  final WorkspaceUserCreatedBy? createdBy;
}

class WorkspaceUserCreatedBy {
  WorkspaceUserCreatedBy({
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
