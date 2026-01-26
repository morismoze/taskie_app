import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/workspace_user.dart';
import '../../../../logger/logger_interface.dart';
import '../../../../utils/command.dart';
import '../../../services/api/user/models/response/user_response.dart';
import '../../../services/api/value_patch.dart';
import '../../../services/api/workspace/workspace_user/models/request/create_virtual_workspace_user_request.dart';
import '../../../services/api/workspace/workspace_user/models/request/update_workspace_user_details_request.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_accumulated_points_response.dart';
import '../../../services/api/workspace/workspace_user/models/response/workspace_user_response.dart';
import '../../../services/api/workspace/workspace_user/workspace_user_api_service.dart';
import '../../../services/local/database_service.dart';
import 'workspace_user_repository.dart';

class WorkspaceUserRepositoryImpl extends WorkspaceUserRepository {
  WorkspaceUserRepositoryImpl({
    required WorkspaceUserApiService workspaceUserApiService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _workspaceUserApiService = workspaceUserApiService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final WorkspaceUserApiService _workspaceUserApiService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  List<WorkspaceUser>? _cachedWorkspaceUsers;

  @override
  List<WorkspaceUser>? get users => _cachedWorkspaceUsers;

  @override
  Stream<Result<List<WorkspaceUser>>> loadWorkspaceUsers({
    required String workspaceId,
    bool forceFetch = false,
  }) async* {
    // Read from in-memory cache
    if (!forceFetch && _cachedWorkspaceUsers != null) {
      yield Result.ok(_cachedWorkspaceUsers!);
    }

    // Read from DB cache
    if (!forceFetch) {
      final dbResult = await _databaseService.getWorkspaceUsers();
      if (dbResult is Ok<List<WorkspaceUser>>) {
        final dbWorkspaceUsers = dbResult.value;
        if (dbWorkspaceUsers.isNotEmpty) {
          _cachedWorkspaceUsers = dbWorkspaceUsers;
          notifyListeners();
          yield Result.ok(dbWorkspaceUsers);
        }
      }
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

        _cachedWorkspaceUsers = mappedData;
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspaceUsers!);

        yield Result.ok(mappedData);
      case Error<List<WorkspaceUserResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.getWorkspaceUsers failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'WorkspaceUserRepositoryImpl',
        );
        yield Result.error(result.error, result.stackTrace);
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

        _cachedWorkspaceUsers!.add(mappedData);
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspaceUsers!);

        return Result.ok(mappedData);
      case Error<WorkspaceUserResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.createVirtualUser failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'WorkspaceUserRepositoryImpl',
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
      final details = _cachedWorkspaceUsers!.firstWhere(
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
        _cachedWorkspaceUsers!.removeWhere(
          (user) => user.id == workspaceUserId,
        );
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspaceUsers!);

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.deleteWorkspaceUser failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'WorkspaceUserRepositoryImpl',
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> updateWorkspaceUserDetails({
    required String workspaceId,
    required String workspaceUserId,
    ValuePatch<String>? firstName,
    ValuePatch<String>? lastName,
    ValuePatch<WorkspaceRole>? role,
  }) async {
    final result = await _workspaceUserApiService.updateWorkspaceUserDetails(
      workspaceId: workspaceId,
      workspaceUserId: workspaceUserId,
      payload: UpdateWorkspaceUserDetailsRequest(
        firstName: firstName,
        lastName: lastName,
        role: role,
      ),
    );

    switch (result) {
      case Ok():
        final updatedWorkspaceUser = _mapWorkspaceUserFromResponse(
          result.value,
        );
        final userIndex = _cachedWorkspaceUsers!.indexWhere(
          (user) => user.id == updatedWorkspaceUser.id,
        );

        if (userIndex != -1) {
          // Update the existing user in the list by replacing it
          // with the new updated instance.
          _cachedWorkspaceUsers![userIndex] = updatedWorkspaceUser;
          notifyListeners();

          // Update persistent cache
          _updateDbCache(_cachedWorkspaceUsers!);
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceUserApiService.updateWorkspaceUserDetails failed',
          error: result.error,
          stackTrace: result.stackTrace,
          context: 'WorkspaceUserRepositoryImpl',
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
          context: 'WorkspaceUserRepositoryImpl',
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<void> purgeWorkspaceUsersCache() async {
    _cachedWorkspaceUsers = null;
    await _databaseService.clearWorkspaceUsers();
  }

  void _updateDbCache(List<WorkspaceUser> payload) async {
    final dbSaveResult = await _databaseService.setWorkspaceUsers(payload);
    if (dbSaveResult is Error<void>) {
      _loggerService.log(
        LogLevel.warn,
        'databaseService.setWorkspaceUsers failed',
        error: dbSaveResult.error,
        stackTrace: dbSaveResult.stackTrace,
        context: 'WorkspaceUserRepositoryImpl',
      );
    }
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
