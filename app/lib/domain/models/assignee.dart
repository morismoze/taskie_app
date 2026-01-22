import 'interfaces/user_interface.dart';

class Assignee implements BaseUser {
  Assignee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.profileImageUrl,
  });

  final String id; // Workspace user ID
  @override
  final String firstName;
  @override
  final String lastName;
  final String? profileImageUrl;

  // Maybe in the future, we will update assignee response to include email
  // as now we don't need it anywhere on this object
  @override
  String? get email => null;

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
