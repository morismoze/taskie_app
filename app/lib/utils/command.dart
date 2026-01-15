import 'package:flutter/foundation.dart';

typedef CommandAction0<T> = Future<Result<T>> Function();
typedef CommandAction1<T, A> = Future<Result<T>> Function(A);

/// Facilitates interaction with a ViewModel.
///
/// Encapsulates an action,
/// exposes its running and error states,
/// and ensures that it can't be launched again until it finishes.
///
/// Use [Command0] for actions without arguments.
/// Use [Command1] for actions with one argument.
///
/// Actions must return a [Result].
///
/// Consume the action result by listening to changes (attaching a event listener),
/// then call to [clearResult] when the state is consumed.
abstract class Command<T> extends ChangeNotifier {
  Command();

  bool _running = false;

  /// True when the action is running
  bool get running => _running;

  Result<T>? _result;

  /// True if action completed with error
  bool get error => _result is Error;

  /// True if action completed successfully
  bool get completed => _result is Ok;

  /// Get last action result
  Result<T>? get result => _result;

  /// Clear last action result
  void clearResult() {
    _result = null;
    notifyListeners();
  }

  /// Internal execute implementation
  Future<void> _execute(CommandAction0<T> action) async {
    // Ensure the action can't launch multiple times.
    // e.g. avoid multiple taps on button
    if (_running) return;

    // Notify listeners
    _running = true;
    _result = null;
    notifyListeners();

    try {
      _result = await action();
    } finally {
      _running = false;
      notifyListeners();
    }
  }
}

/// [Command] without arguments.
/// Takes a [CommandAction0] as action.
class Command0<T> extends Command<T> {
  Command0(this._action);

  final CommandAction0<T> _action;

  /// Executes the action.
  Future<void> execute() async {
    await _execute(_action);
  }
}

/// [Command] with one argument.
/// Takes a [CommandAction1] as action.
class Command1<T, A> extends Command<T> {
  Command1(this._action);

  final CommandAction1<T, A> _action;

  /// Executes the action with the argument.
  Future<void> execute(A argument) async {
    await _execute(() => _action(argument));
  }
}

sealed class Result<T> {
  const Result();

  /// Creates a successful [Result], completed with the specified [value].
  const factory Result.ok(T value) = Ok._;

  /// Creates an error [Result], completed with the specified [error].
  const factory Result.error(Exception error, [StackTrace? stackTrace]) =
      Error._;
}

final class Ok<T> extends Result<T> {
  const Ok._(this.value);

  final T value;

  @override
  String toString() => 'Result<$T>.ok($value)';
}

final class Error<T> extends Result<T> {
  const Error._(this.error, [this.stackTrace]);

  final Exception error;
  final StackTrace? stackTrace;

  @override
  String toString() => 'Result<$T>.error($error)';
}

Future<Result<T>> firstOkOrLastError<T>(Stream<Result<T>> stream) async {
  Result<T>? last;

  await for (final r in stream) {
    last = r;
    if (r is Ok<T>) {
      return r;
    }
  }

  // Stream ended without Ok

  if (last is Error<T>) {
    return last;
  }

  return Result.error(Exception('Stream emitted no values'));
}
