import '../../data/services/api/user/models/response/user_response.dart';

class WorkspaceUser {
  WorkspaceUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String? email;
  final String? profileImageUrl;
}
