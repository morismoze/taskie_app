import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/workspace_user.dart';
import '../../../../utils/command.dart';
import '../../../services/api/user/models/response/user_response.dart';
import '../../../services/api/workspace/workspace_user/models/request/create_virtual_workspace_user_request.dart';
import '../../../services/api/workspace/workspace_user/models/request/update_workspace_user_details_request.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_accumulated_points_response.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_response.dart';
import '../../../services/api/workspace/workspace_user/workspace_user_api_service.dart';
import '../../../services/local/logger.dart';
import 'workspace_user_repository.dart';

class WorkspaceUserRepositoryImpl extends WorkspaceUserRepository {
  WorkspaceUserRepositoryImpl({
    required WorkspaceUserApiService workspaceUserApiService,
    required LoggerService loggerService,
  }) : _workspaceUserApiService = workspaceUserApiService,
       _loggerService = loggerService;

  final WorkspaceUserApiService _workspaceUserApiService;
  final LoggerService _loggerService;

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

    final result = await _workspaceUserApiService.getWorkspaceUsers(
      workspaceId,
    );

    switch (result) {
      case Ok<List<WorkspaceUserResponse>>():
        final mappedData = result.value
            .map(
              (workspaceUser) => _mapWorkspaceUserFromResponse(workspaceUser),
            )
            .toList();

        _cachedWorkspaceUsersList = mappedData;
        notifyListeners();

        return Result.ok(mappedData);
      case Error<List<WorkspaceUserResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.getWorkspaceUsers failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<WorkspaceUser>> createVirtualMember({
    required String workspaceId,
    required String firstName,
    required String lastName,
  }) async {
    final result = await _workspaceUserApiService.createVirtualUser(
      workspaceId: workspaceId,
      payload: CreateVirtualWorkspaceUserRequest(
        firstName: firstName,
        lastName: lastName,
      ),
    );

    switch (result) {
      case Ok<WorkspaceUserResponse>():
        final mappedData = _mapWorkspaceUserFromResponse(result.value);

        _cachedWorkspaceUsersList!.add(mappedData);
        notifyListeners();

        return Result.ok(mappedData);
      case Error<WorkspaceUserResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.createVirtualUser failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Result<WorkspaceUser> loadWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
  }) {
    try {
      final details = _cachedWorkspaceUsersList!.firstWhere(
        (user) => user.id == workspaceUserId,
      );
      return Result.ok(details);
    } on StateError {
      return Result.error(
        Exception('Workspace user $workspaceUserId not found'),
      );
    }
  }

  @override
  Future<Result<void>> deleteWorkspaceUser({
    required String workspaceId,
    required String workspaceUserId,
  }) async {
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
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.deleteWorkspaceUser failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> updateWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
    String? firstName,
    String? lastName,
    WorkspaceRole? role,
  }) async {
    final result = await _workspaceUserApiService.updateWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
      payload: UpdateWorkspaceUserDetailsRequest(
        firstName: firstName,
        lastName: lastName,
        role: role?.value,
      ),
    );

    switch (result) {
      case Ok():
        final updatedWorkspaceUser = _mapWorkspaceUserFromResponse(
          result.value,
        );
        final userIndex = _cachedWorkspaceUsersList!.indexWhere(
          (user) => user.id == updatedWorkspaceUser.id,
        );

        if (userIndex != -1) {
          // Update the existing user in the list by replacing it
          // with the new updated instance.
          _cachedWorkspaceUsersList![userIndex] = updatedWorkspaceUser;
          notifyListeners();
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.updateWorkspaceUserDetails failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<int>> getWorkspaceUserAccumulatedPoints({
    required String workspaceId,
    required String workspaceUserId,
  }) async {
    final result = await _workspaceUserApiService
        .getWorkspaceUserAccumulatedPoints(
          workspaceId: workspaceId,
          workspaceUserId: workspaceUserId,
        );

    switch (result) {
      case Ok<WorkspaceUserAccumulatedPointsResponse>():
        return Result.ok(result.value.accumulatedPoints);
      case Error<WorkspaceUserAccumulatedPointsResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.getWorkspaceUserAccumulatedPoints failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  void purgeWorkspaceUsersCache() {
    _cachedWorkspaceUsersList = null;
  }

  WorkspaceUser _mapWorkspaceUserFromResponse(
    WorkspaceUserResponse workspaceUser,
  ) {
    return WorkspaceUser(
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
          : CreatedBy(
              id: workspaceUser.createdBy!.id,
              firstName: workspaceUser.createdBy!.firstName,
              lastName: workspaceUser.createdBy!.lastName,
              profileImageUrl: workspaceUser.createdBy!.profileImageUrl,
            ),
    );
  }
}
