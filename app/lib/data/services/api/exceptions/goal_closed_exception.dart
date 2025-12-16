// This exception is used when there was an attempt at
// updating a goal, but the it was closed in the
// meantime (e.g. by another Manager).
class GoalClosedException implements Exception {
  const GoalClosedException();
}
