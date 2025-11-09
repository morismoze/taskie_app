// This exception is used when there was an attempt at
// updating a task's assignments, but the task one or
// more assignees was removed in the meanwhile (e.g. by another Manager).
class TaskAssigneesInvalidException implements Exception {
  const TaskAssigneesInvalidException();
}
