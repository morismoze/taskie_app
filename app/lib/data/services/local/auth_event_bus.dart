import 'dart:async';

sealed class AuthEvent {}

class UserRoleChangedEvent extends AuthEvent {}

class UserRemovedFromWorkspaceEvent extends AuthEvent {}

class AuthEventBus {
  final _controller = StreamController<AuthEvent>.broadcast();

  Stream<AuthEvent> get events => _controller.stream;

  void emit(AuthEvent event) {
    if (!_controller.isClosed) {
      _controller.add(event);
    }
  }

  void dispose() {
    _controller.close();
  }
}
