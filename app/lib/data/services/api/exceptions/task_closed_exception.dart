// This exception is used when there was an attempt at
// updating a task and/or its assignments, but the task
// was closed in the meantime (e.g. by another Manager).
class TaskClosedException implements Exception {
  const TaskClosedException();
}
