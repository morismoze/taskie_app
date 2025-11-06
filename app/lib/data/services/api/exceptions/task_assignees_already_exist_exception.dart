// This exception is used when there was an attempt at
// adding new task's assignments, but the task already has
// one or more of the provided assignees (10). This could be because those
// new assignees could have been added in the meanwhile (e.g. by another Manager).
class TaskAssigneesAlreadyExistException implements Exception {
  const TaskAssigneesAlreadyExistException();
}
