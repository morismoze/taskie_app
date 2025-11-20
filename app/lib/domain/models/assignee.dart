class Assignee {
  Assignee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id; // Workspace user ID
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
