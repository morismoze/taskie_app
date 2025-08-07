import '../../data/services/api/user/models/response/user_response.dart';
import 'created_by.dart';

class WorkspaceUser {
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
  final String firstName;
  final String lastName;
  final WorkspaceRole role;
  final String userId;
  final DateTime createdAt;
  final String? email;
  final String? profileImageUrl;
  final CreatedBy? createdBy;
}
