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

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'profileImageUrl': profileImageUrl,
  };

  factory Assignee.fromMap(Map<dynamic, dynamic> map) => Assignee(
    id: map['id'] as String,
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    profileImageUrl: map['profileImageUrl'] as String?,
  );
}
