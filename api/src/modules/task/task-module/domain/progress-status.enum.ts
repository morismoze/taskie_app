export enum ProgressStatus {
  IN_PROGRESS = 'IN_PROGRESS',
  COMPLETED = 'COMPLETED',
  // This is used on a task which was marked as completed even though its dueDate expired
  COMPLETED_AS_STALE = 'COMPLETED_AS_STALE',
  NOT_COMPLETED = 'NOT_COMPLETED',
  CLOSED = 'CLOSED',
}
