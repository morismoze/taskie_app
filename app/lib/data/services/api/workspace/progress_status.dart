import 'package:json_annotation/json_annotation.dart';

enum ProgressStatus {
  @JsonValue('IN_PROGRESS')
  inProgress('IN_PROGRESS'),

  @JsonValue('COMPLETED')
  completed('COMPLETED'),

  /// This is used on a task which was marked as completed even though its dueDate expired
  @JsonValue('COMPLETED_AS_STALE')
  completedAsStale('COMPLETED_AS_STALE'),

  @JsonValue('NOT_COMPLETED')
  notCompleted('NOT_COMPLETED'),

  @JsonValue('CLOSED')
  closed('CLOSED');

  const ProgressStatus(this.value);

  final String value;
}
