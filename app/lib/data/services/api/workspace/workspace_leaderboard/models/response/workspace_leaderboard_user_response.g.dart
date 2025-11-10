// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workspace_leaderboard_user_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WorkspaceLeaderboardUserResponse _$WorkspaceLeaderboardUserResponseFromJson(
  Map<String, dynamic> json,
) => WorkspaceLeaderboardUserResponse(
  id: json['id'] as String,
  firstName: json['firstName'] as String,
  lastName: json['lastName'] as String,
  accumulatedPoints: (json['accumulatedPoints'] as num).toInt(),
  completedTasks: (json['completedTasks'] as num).toInt(),
  profileImageUrl: json['profileImageUrl'] as String?,
);
