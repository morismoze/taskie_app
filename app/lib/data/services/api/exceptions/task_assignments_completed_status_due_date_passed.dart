// This exception is used when there was an attempt at adding updating status/es of a
// task's assignments to Completed status, but the task's due date has passed. When
// due date passes, only Completed as Stale is acceptable, not Completed.
class TaskAssignmentsCompletedStatusDueDatePassed implements Exception {
  const TaskAssignmentsCompletedStatusDueDatePassed();
}
