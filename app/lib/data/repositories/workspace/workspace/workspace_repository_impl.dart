import 'package:flutter/foundation.dart';

import '../../../../domain/models/created_by.dart';
import '../../../../domain/models/workspace.dart';
import '../../../../utils/command.dart';
import '../../../services/api/workspace/workspace/models/request/create_workspace_request.dart';
import '../../../services/api/workspace/workspace/models/request/update_workspace_details_request.dart';
import '../../../services/api/workspace/workspace/models/response/workspace_response.dart';
import '../../../services/api/workspace/workspace/workspace_api_service.dart';
import '../../../services/local/database_service.dart';
import '../../../services/local/logger_service.dart';
import '../../../services/local/shared_preferences_service.dart';
import 'workspace_repository.dart';

class WorkspaceRepositoryImpl extends WorkspaceRepository {
  WorkspaceRepositoryImpl({
    required WorkspaceApiService workspaceApiService,
    required SharedPreferencesService sharedPreferencesService,
    required DatabaseService databaseService,
    required LoggerService loggerService,
  }) : _workspaceApiService = workspaceApiService,
       _sharedPreferencesService = sharedPreferencesService,
       _databaseService = databaseService,
       _loggerService = loggerService;

  final WorkspaceApiService _workspaceApiService;
  final SharedPreferencesService _sharedPreferencesService;
  final DatabaseService _databaseService;
  final LoggerService _loggerService;

  List<Workspace>? _cachedWorkspacesList;

  @override
  List<Workspace>? get workspaces => _cachedWorkspacesList;

  String? _activeWorkspaceId;

  @override
  String? get activeWorkspaceId => _activeWorkspaceId;

  final ValueNotifier<bool?> _hasNoWorkspacesNotifier = ValueNotifier(null);

  // This is listenable used for redirection to workspace creation
  // screen in case user is not part of any workspace.
  @override
  ValueNotifier<bool?> get hasNoWorkspacesNotifier => _hasNoWorkspacesNotifier;

  @override
  Future<Result<void>> setActiveWorkspaceId(String? workspaceId) async {
    if (workspaceId == null) {
      // Back to init value
      final result = await _sharedPreferencesService.deleteActiveWorkspaceId();

      switch (result) {
        case Ok():
          _activeWorkspaceId = null;
          return const Result.ok(null);
        case Error():
          _loggerService.log(
            LogLevel.warn,
            'sharedPreferencesService.setActiveWorkspaceId failed',
            error: result.error,
            stackTrace: result.stackTrace,
          );
          return Result.error(result.error, result.stackTrace);
      }
    }

    if (_activeWorkspaceId == workspaceId) {
      // Early return if the same workspaceId is already set
      return const Result.ok(null);
    }

    final result = await _sharedPreferencesService.setActiveWorkspaceId(
      workspaceId: workspaceId,
    );

    switch (result) {
      case Ok():
        _activeWorkspaceId = workspaceId;
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'sharedPreferencesService.setActiveWorkspaceId failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
    }

    return result;
  }

  @override
  Future<Result<String?>> loadActiveWorkspaceId() async {
    if (_activeWorkspaceId != null) {
      return Result.ok(_activeWorkspaceId);
    }

    final result = await _sharedPreferencesService.getActiveWorkspaceId();
    switch (result) {
      case Ok<String?>():
        _activeWorkspaceId ??= result.value;
        return Result.ok(result.value);
      case Error<String?>():
        _loggerService.log(
          LogLevel.warn,
          'sharedPreferencesService.getActiveWorkspaceId failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Stream<Result<List<Workspace>>> loadWorkspaces({
    bool forceFetch = false,
  }) async* {
    // Read from in-memory cache
    if (!forceFetch && _cachedWorkspacesList != null) {
      yield Result.ok(_cachedWorkspacesList!);
    }

    // Read from DB cache
    if (!forceFetch) {
      final dbResult = await _databaseService.getWorkspaces();
      if (dbResult is Ok<List<Workspace>>) {
        final dbWorkspaces = dbResult.value;
        if (dbWorkspaces.isNotEmpty) {
          _cachedWorkspacesList = dbWorkspaces;
          notifyListeners();
          yield Result.ok(dbWorkspaces);
        }
      }
    }

    // Trigger API request
    final result = await _workspaceApiService.getWorkspaces();
    switch (result) {
      case Ok<List<WorkspaceResponse>>():
        final mappedData = result.value
            .map((workspace) => _mapWorkspaceFromResponse(workspace))
            .toList();

        _cachedWorkspacesList = mappedData;
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspacesList!);

        // If user is not part of any workspace, notify the navigation redirection listener
        if (_cachedWorkspacesList!.isEmpty) {
          _hasNoWorkspacesNotifier.value = _cachedWorkspacesList!.isEmpty;
        }

        yield Result.ok(mappedData);
      case Error<List<WorkspaceResponse>>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceApiService.getWorkspaces failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        yield Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<String>> createWorkspace({
    required String name,
    String? description,
  }) async {
    final payload = CreateWorkspaceRequest(
      name: name,
      description: description,
    );
    final result = await _workspaceApiService.createWorkspace(payload);

    switch (result) {
      case Ok<WorkspaceResponse>():
        final newWorkspace = _mapWorkspaceFromResponse(result.value);

        // Initialize the list if null
        _cachedWorkspacesList ??= <Workspace>[];
        // Add the new workspace to the local list (cache)
        _cachedWorkspacesList!.add(newWorkspace);
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspacesList!);

        // We need to update [_hasNoWorkspacesNotifier] notifier, but just
        // in the case user now is part of only one workspace for 2 reasons:
        // 1. when user is not part of any workspace and creates a workspace for the first time
        // 2. we don't want to trigger this everytime user creates new workspace, because
        // we don't want the gorouter redirect function to re-trigger everytime.
        if (_cachedWorkspacesList!.length == 1) {
          _hasNoWorkspacesNotifier.value = false;
        }

        return Result.ok(newWorkspace.id);
      case Error<WorkspaceResponse>():
        _loggerService.log(
          LogLevel.warn,
          'workspaceApiService.createWorkspace failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> leaveWorkspace({required String workspaceId}) async {
    if (_cachedWorkspacesList == null) {
      return Result.error(Exception('Workspaces cache is null'));
    }

    final result = await _workspaceApiService.leaveWorkspace(workspaceId);

    switch (result) {
      case Ok():
        // Remove the leaving workspace from the local list (cache)
        final leavingWorkspace = _cachedWorkspacesList?.firstWhere(
          (workspace) => workspace.id == workspaceId,
        );
        _cachedWorkspacesList!.remove(leavingWorkspace);
        notifyListeners();

        // Update persistent cache
        _updateDbCache(_cachedWorkspacesList!);

        // If user is no more part of any workspace, notify the navigation redirection listener
        if (_cachedWorkspacesList!.isEmpty) {
          _hasNoWorkspacesNotifier.value = _cachedWorkspacesList!.isEmpty;
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceApiService.leaveWorkspace failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Result<Workspace> loadWorkspaceDetails(String workspaceId) {
    try {
      final details = _cachedWorkspacesList!.firstWhere(
        (workspace) => workspace.id == workspaceId,
      );
      return Result.ok(details);
    } on StateError {
      return Result.error(Exception('Workspace $workspaceId not found'));
    }
  }

  @override
  Future<Result<void>> updateWorkspaceDetails(
    String workspaceId, {
    String? name,
    String? description,
  }) async {
    final result = await _workspaceApiService.updateWorkspaceDetails(
      workspaceId: workspaceId,
      payload: UpdateWorkspaceDetailsRequest(
        name: name,
        description: description,
      ),
    );

    switch (result) {
      case Ok():
        final updatedWorkspace = _mapWorkspaceFromResponse(result.value);
        final workspaceIndex = _cachedWorkspacesList!.indexWhere(
          (workspace) => workspace.id == updatedWorkspace.id,
        );

        if (workspaceIndex != -1) {
          // Update the existing workspace in the list by replacing it
          // with the new updated instance.
          _cachedWorkspacesList![workspaceIndex] = updatedWorkspace;
          notifyListeners();

          // Update persistent cache
          _updateDbCache(_cachedWorkspacesList!);
        }

        return const Result.ok(null);
      case Error():
        _loggerService.log(
          LogLevel.warn,
          'workspaceApiService.updateWorkspaceDetails failed',
          error: result.error,
          stackTrace: result.stackTrace,
        );
        return Result.error(result.error, result.stackTrace);
    }
  }

  @override
  Future<Result<void>> addWorkspace({required Workspace workspace}) async {
    if (_cachedWorkspacesList != null) {
      _cachedWorkspacesList!.add(workspace);
      notifyListeners();

      // Update persistent cache
      _updateDbCache(_cachedWorkspacesList!);

      return const Result.ok(null);
    }

    return Result.error(Exception('Cached list was not initialized'));
  }

  @override
  Future<void> purgeWorkspacesCache() async {
    _cachedWorkspacesList = null;
    await _databaseService.clearWorkspaces();
    await setActiveWorkspaceId(null);
    _hasNoWorkspacesNotifier.value = null;
  }

  @override
  void dispose() {
    _hasNoWorkspacesNotifier.dispose();
    super.dispose();
  }

  Workspace _mapWorkspaceFromResponse(WorkspaceResponse workspace) {
    return Workspace(
      id: workspace.id,
      name: workspace.name,
      createdAt: workspace.createdAt,
      description: workspace.description,
      pictureUrl: workspace.pictureUrl,
      createdBy: workspace.createdBy == null
          ? null
          : CreatedBy(
              id: workspace.createdBy!.id,
              firstName: workspace.createdBy!.firstName,
              lastName: workspace.createdBy!.lastName,
              profileImageUrl: workspace.createdBy!.profileImageUrl,
            ),
    );
  }

  void _updateDbCache(List<Workspace> payload) async {
    final dbSaveResult = await _databaseService.setWorkspaces(payload);
    if (dbSaveResult is Error<void>) {
      _loggerService.log(
        LogLevel.warn,
        'databaseService.setWorkspaces failed',
        error: dbSaveResult.error,
      );
    }
  }
}
