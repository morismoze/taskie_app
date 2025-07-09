import 'package:json_annotation/json_annotation.dart';

import '../../../paginable.dart';

part 'task_response.g.dart';

@JsonSerializable()
class TaskResponse {
  TaskResponse({
    required this.id,
    required this.title,
    required this.rewardPoints,
    required this.createdAt,
    required this.assignees,
    this.email,
    this.profileImageUrl,
  });

  final String id;
  final String title;
  final int rewardPoints;
  final String createdAt;
  final List<Assignee> assignees;
  final String? email;
  final String? profileImageUrl;

  factory TaskResponse.fromJson(Map<String, dynamic> json) =>
      _$TaskResponseFromJson(json);
}

@JsonSerializable()
class Assignee {
  Assignee({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.status,
    this.profileImageUrl,
  });

  final String id;
  final String firstName;
  final String lastName;
  final ProgressStatus status;
  final String? profileImageUrl;

  factory Assignee.fromJson(Map<String, dynamic> json) =>
      _$AssigneeFromJson(json);
}

enum ProgressStatus {
  @JsonValue('IN_PROGRESS')
  inProgress('IN_PROGRESS'),

  @JsonValue('COMPLETED')
  completed('COMPLETED'),

  /// This is used on a task which was marked as completed even though its dueDate expired
  @JsonValue('COMPLETED_AS_STALE')
  completedAsStale('COMPLETED_AS_STALE'),

  @JsonValue('CLOSED')
  closed('CLOSED');

  const ProgressStatus(this.value);

  final String value;
}

class PaginableObjectivesRequestQueryParams
    extends PaginableRequestQueryParams {
  PaginableObjectivesRequestQueryParams({
    required super.page,
    required super.limit,
    required super.search,
    required this.status,
  });

  final ProgressStatus status;
}
