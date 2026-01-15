import 'package:json_annotation/json_annotation.dart';

part 'workspace_user_accumulated_points_response.g.dart';

@JsonSerializable(createToJson: false)
class WorkspaceUserAccumulatedPointsResponse {
  WorkspaceUserAccumulatedPointsResponse({required this.accumulatedPoints});

  final int accumulatedPoints;

  factory WorkspaceUserAccumulatedPointsResponse.fromJson(
    Map<String, dynamic> json,
  ) => _$WorkspaceUserAccumulatedPointsResponseFromJson(json);
}
