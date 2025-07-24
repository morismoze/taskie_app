class Assignee {
  Assignee({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;
}
