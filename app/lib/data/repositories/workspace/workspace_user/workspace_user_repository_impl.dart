import 'package:logging/logging.dart';

import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_response.dart';
import '../../../services/api/workspace/workspace_user/workspace_user_api_service.dart';
import 'workspace_user_repository.dart';

class WorkspaceUserRepositoryImpl implements WorkspaceUserRepository {
  WorkspaceUserRepositoryImpl({
    required WorkspaceUserApiService workspaceUserApiService,
  }) : _workspaceUserApiService = workspaceUserApiService;

  final WorkspaceUserApiService _workspaceUserApiService;

  final _log = Logger('WorkspaceUserRepository');
  List<WorkspaceUser>? _cachedWorkspaceUsersList;

  @override
  Future<Result<List<WorkspaceUser>>> getWorkspaceUsers({
    required String workspaceId,
    bool forceFetch = false,
  }) async {
    if (!forceFetch && _cachedWorkspaceUsersList != null) {
      return Result.ok(_cachedWorkspaceUsersList!);
    }

    try {
      final result = await _workspaceUserApiService.getWorkspaceUsers(
        workspaceId,
      );

      switch (result) {
        case Ok<List<WorkspaceUserResponse>>():
          final mappedData = result.value
              .map(
                (workspaceUser) => WorkspaceUser(
                  id: workspaceUser.id,
                  firstName: workspaceUser.firstName,
                  lastName: workspaceUser.lastName,
                  role: workspaceUser.role,
                  profileImageUrl: workspaceUser.profileImageUrl,
                ),
              )
              .toList();
          _cachedWorkspaceUsersList = mappedData;

          return Result.ok(mappedData);
        case Error<List<WorkspaceUserResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
