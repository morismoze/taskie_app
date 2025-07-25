class Workspace {
  Workspace({
    required this.id,
    required this.name,
    required this.createdAt,
    this.description,
    this.pictureUrl,
    this.createdBy,
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
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
