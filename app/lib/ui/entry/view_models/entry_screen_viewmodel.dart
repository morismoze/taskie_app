import '../../../data/repositories/user/user_repository.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../utils/command.dart';

class EntryScreenViewModel {
  EntryScreenViewModel({
    required UserRepository userRepository,
    required WorkspaceRepository workspaceRepository,
  }) : _userRepository = userRepository,
       _workspaceRepository = workspaceRepository {
    setupInitial = Command0(_setupInitial)..execute();
  }

  final UserRepository _userRepository;
  final WorkspaceRepository _workspaceRepository;

  /// Initial setup before proceeding to the app.
  ///
  /// Returns workspaceId of the workspace to navigate to or null
  /// if the loaded workspaces list is empty.
  late Command0 setupInitial;

  Future<Result<String?>> _setupInitial() async {
    // 1. Load user
    final resultLoadUser = await _userRepository.loadUser();

    switch (resultLoadUser) {
      case Ok():
        break;
      case Error():
        return Result.error(resultLoadUser.error);
    }

    // 2. Load workspaces
    final resultLoadWorkspaces = await _workspaceRepository.loadWorkspaces();

    switch (resultLoadWorkspaces) {
      case Ok():
        if (resultLoadWorkspaces.value.isEmpty) {
          // Return null in the case workspaces list is empty, because
          // gorouter redirect function will kick in automatically in this case
          // and will redirect the user to workspaces/create/initial screen.
          return const Result.ok(null);
        }
        break;
      case Error():
        return Result.error(resultLoadWorkspaces.error);
    }

    // 3.a Load active workspace IDs
    final activeWorkspaceIdResult = await _workspaceRepository
        .loadActiveWorkspaceId();

    if (activeWorkspaceIdResult is Error<String?>) {
      return Result.error(activeWorkspaceIdResult.error);
    }

    final activeWorkspaceId = (activeWorkspaceIdResult as Ok<String?>).value;
    if (activeWorkspaceId != null) {
      return Result.ok(activeWorkspaceIdResult.value);
    } else {
      // 3.b Set active workspace ID if active workspace ID from shared prefs is null.
      // This can happen when user has either:
      // 1. launched the app for the first time
      // 2. deleted application storage
      final firstWorkspaceId = resultLoadWorkspaces.value.first.id;
      final resultSetActiveWorkspaceId = await _workspaceRepository
          .setActiveWorkspaceId(firstWorkspaceId);

      switch (resultSetActiveWorkspaceId) {
        case Ok():
          return Result.ok(firstWorkspaceId);
        case Error():
          return Result.error(resultSetActiveWorkspaceId.error);
      }
    }
  }
}
