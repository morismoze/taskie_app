class Workspace {
  Workspace({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.description,
    required this.pictureUrl,
    required this.createdBy,
  });

  final String id;
  final String name;
  final DateTime createdAt;
  final String? description;
  final String? pictureUrl;
  final WorkspaceCreatedBy? createdBy;
}

class WorkspaceCreatedBy {
  WorkspaceCreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
