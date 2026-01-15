class CreatedBy {
  CreatedBy({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final String? profileImageUrl;

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'profileImageUrl': profileImageUrl,
  };

  factory CreatedBy.fromMap(Map<dynamic, dynamic> map) => CreatedBy(
    id: map['id'] as String,
    firstName: map['firstName'] as String,
    lastName: map['lastName'] as String,
    profileImageUrl: map['profileImageUrl'] as String?,
  );
}
