import 'interfaces/user_interface.dart';

class WorkspaceLeaderboardUser implements BaseUser {
  WorkspaceLeaderboardUser({
    required this.id, // workspace user ID
    required this.firstName,
    required this.lastName,
    required this.accumulatedPoints,
    required this.completedTasks,
    required this.profileImageUrl,
  });

  final String id;
  @override
  final String firstName;
  @override
  final String lastName;
  final int accumulatedPoints;
  final int completedTasks;
  final String? profileImageUrl;

  // Maybe in the future, we will update assignee response to include email
  // as now we don't need it anywhere on this object
  @override
  String? get email => null;

  Map<String, dynamic> toMap() => {
    'id': id,
    'firstName': firstName,
    'lastName': lastName,
    'accumulatedPoints': accumulatedPoints,
    'completedTasks': completedTasks,
    'profileImageUrl': profileImageUrl,
  };

  factory WorkspaceLeaderboardUser.fromMap(Map<dynamic, dynamic> map) =>
      WorkspaceLeaderboardUser(
        id: map['id'] as String,
        firstName: map['firstName'] as String,
        lastName: map['lastName'] as String,
        accumulatedPoints: (map['accumulatedPoints'] as num).toInt(),
        completedTasks: (map['completedTasks'] as num).toInt(),
        profileImageUrl: map['profileImageUrl'] as String?,
      );
}
