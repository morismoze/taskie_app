import 'package:logging/logging.dart';

import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace_user/models/request/create_virtual_workspace_user_request.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_response.dart';
import '../../../services/api/workspace/workspace_user/workspace_user_api_service.dart';
import 'workspace_user_repository.dart';

class WorkspaceUserRepositoryImpl extends WorkspaceUserRepository {
  WorkspaceUserRepositoryImpl({
    required WorkspaceUserApiService workspaceUserApiService,
  }) : _workspaceUserApiService = workspaceUserApiService;

  final WorkspaceUserApiService _workspaceUserApiService;

  final _log = Logger('WorkspaceUserRepository');
  List<WorkspaceUser>? _cachedWorkspaceUsersList;

  @override
  List<WorkspaceUser>? get users => _cachedWorkspaceUsersList;

  @override
  Future<Result<List<WorkspaceUser>>> loadWorkspaceUsers({
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
                  userId: workspaceUser.userId,
                  createdAt: workspaceUser.createdAt,
                  email: workspaceUser.email,
                  profileImageUrl: workspaceUser.profileImageUrl,
                  createdBy: workspaceUser.createdBy == null
                      ? null
                      : WorkspaceUserCreatedBy(
                          firstName: workspaceUser.createdBy!.firstName,
                          lastName: workspaceUser.createdBy!.lastName,
                          profileImageUrl:
                              workspaceUser.createdBy!.profileImageUrl,
                        ),
                ),
              )
              .toList();

          _cachedWorkspaceUsersList = mappedData;
          notifyListeners();

          return Result.ok(mappedData);
        case Error<List<WorkspaceUserResponse>>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Future<Result<WorkspaceUser>> createVirtualMember({
    required String workspaceId,
    required String firstName,
    required String lastName,
  }) async {
    try {
      final result = await _workspaceUserApiService.createVirtualUser(
        workspaceId: workspaceId,
        payload: CreateVirtualWorkspaceUserRequest(
          firstName: firstName,
          lastName: lastName,
        ),
      );

      switch (result) {
        case Ok<WorkspaceUserResponse>():
          final workspaceUser = result.value;

          final mappedData = WorkspaceUser(
            id: workspaceUser.id,
            firstName: workspaceUser.firstName,
            lastName: workspaceUser.lastName,
            role: workspaceUser.role,
            userId: workspaceUser.userId,
            createdAt: workspaceUser.createdAt,
            email: workspaceUser.email,
            profileImageUrl: workspaceUser.profileImageUrl,
            createdBy: workspaceUser.createdBy == null
                ? null
                : WorkspaceUserCreatedBy(
                    firstName: workspaceUser.createdBy!.firstName,
                    lastName: workspaceUser.createdBy!.lastName,
                    profileImageUrl: workspaceUser.createdBy!.profileImageUrl,
                  ),
          );

          _cachedWorkspaceUsersList!.add(mappedData);
          notifyListeners();

          return Result.ok(mappedData);
        case Error<WorkspaceUserResponse>():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  Result<WorkspaceUser> loadWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
  }) {
    final workspaceUserDetails = _cachedWorkspaceUsersList!.firstWhere(
      (user) => user.id == workspaceUserId,
    );
    return Result.ok(workspaceUserDetails);
  }

  @override
  Future<Result<void>> deleteWorkspaceUser({
    required String workspaceId,
    required String workspaceUserId,
  }) async {
    try {
      final result = await _workspaceUserApiService.deleteWorkspaceUser(
        workspaceId: workspaceId,
        workspaceUserId: workspaceUserId,
      );

      switch (result) {
        case Ok():
          _cachedWorkspaceUsersList!.removeWhere(
            (user) => user.id == workspaceUserId,
          );
          notifyListeners();

          return const Result.ok(null);
        case Error():
          return Result.error(result.error);
      }
    } on Exception catch (e) {
      return Result.error(e);
    }
  }

  @override
  void purgeWorkspaceUsersCache() {
    _cachedWorkspaceUsersList = null;
  }
}
