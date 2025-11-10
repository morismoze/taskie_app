class WorkspaceLeaderboardUser {
  WorkspaceLeaderboardUser({
    required this.id, // workspace user ID
    required this.firstName,
    required this.lastName,
    required this.accumulatedPoints,
    required this.completedTasks,
    required this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final int accumulatedPoints;
  final int completedTasks;
  final String? profileImageUrl;
}
