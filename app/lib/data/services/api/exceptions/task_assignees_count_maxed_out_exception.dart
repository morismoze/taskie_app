// This exception is used when there was an attempt at
// adding new task's assignments, but the task already has
// maximum number of assignees (10). This could be because new
// assignees could have been added in the meanwhile (e.g. by another Manager).
class TaskAssigneesCountMaxedOutException implements Exception {
  const TaskAssigneesCountMaxedOutException();
}
