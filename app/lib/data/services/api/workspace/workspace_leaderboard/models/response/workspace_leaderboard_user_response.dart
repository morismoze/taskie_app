import 'package:json_annotation/json_annotation.dart';

part 'workspace_leaderboard_user_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceLeaderboardUserResponse {
  WorkspaceLeaderboardUserResponse({
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

  factory WorkspaceLeaderboardUserResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkspaceLeaderboardUserResponseFromJson(json);
}
