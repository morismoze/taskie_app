export enum ProgressStatus {
  IN_PROGRESS,
  COMPLETED,
  // This is used on a task which was marked as completed even though its dueDate expired
  COMPLETED_AS_STALE,
  CLOSED,
}
