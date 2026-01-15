import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

import '../../../config/environment/env.dart';
import '../../../data/repositories/workspace/workspace/workspace_repository.dart';
import '../../../data/repositories/workspace/workspace_invite/workspace_invite_repository.dart';
import '../../../data/repositories/workspace/workspace_user/workspace_user_repository.dart';
import '../../../domain/models/workspace.dart';
import '../../../domain/use_cases/share_workspace_invite_link_use_case.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';

class CreateWorkspaceUserScreenViewModel extends ChangeNotifier {
  CreateWorkspaceUserScreenViewModel({
    required String workspaceId,
    required WorkspaceRepository workspaceRepository,
    required WorkspaceInviteRepository workspaceInviteRepository,
    required WorkspaceUserRepository workspaceUserRepository,
    required ShareWorkspaceInviteLinkUseCase shareWorkspaceInviteLinkUseCase,
  }) : _activeWorkspaceId = workspaceId,
       _workspaceRepository = workspaceRepository,
       _workspaceInviteRepository = workspaceInviteRepository,
       _workspaceUserRepository = workspaceUserRepository,
       _shareWorkspaceInviteLinkUseCase = shareWorkspaceInviteLinkUseCase {
    createWorkspaceInviteLink = Command1(_createWorkspaceInviteLink)
      ..execute(null);
    shareWorkspaceInviteLink = Command0(_shareWorkspaceInviteLink);
    createVirtualUser = Command1(_createVirtualUser);
    _loadWorkspaceDetails();
  }

  final String _activeWorkspaceId;
  final WorkspaceRepository _workspaceRepository;
  final WorkspaceInviteRepository _workspaceInviteRepository;
  final WorkspaceUserRepository _workspaceUserRepository;
  final ShareWorkspaceInviteLinkUseCase _shareWorkspaceInviteLinkUseCase;

  /// Returns [ShareResult] from share_plus
  late Command0<ShareResult> shareWorkspaceInviteLink;

  /// Returns invite link
  late Command1<String, bool?> createWorkspaceInviteLink;
  late Command1<void, (String firstName, String lastName)> createVirtualUser;
  Workspace? _activeWorkspaceDetails;

  String get activeWorkspaceId => _activeWorkspaceId;

  String? _workspaceInviteLink;

  void _loadWorkspaceDetails() {
    final activeWorkspaceDetailsResult = _workspaceRepository
        .loadWorkspaceDetails(_activeWorkspaceId);

    switch (activeWorkspaceDetailsResult) {
      case Ok():
        _activeWorkspaceDetails = activeWorkspaceDetailsResult.value;
        return;
      case Error():
    }
  }

  Future<Result<String>> _createWorkspaceInviteLink([bool? forceFetch]) async {
    final result = await _workspaceInviteRepository.createWorkspaceInviteToken(
      workspaceId: _activeWorkspaceId,
      forceFetch: forceFetch ?? false,
    );

    switch (result) {
      case Ok():
        final inviteToken = result.value.token;
        final workspaceJoinDeepLinkRoute = Routes.workspaceJoin(inviteToken);
        final serverBaseUrl = Env.deepLinkBaseUrl;
        final inviteLink = '$serverBaseUrl$workspaceJoinDeepLinkRoute';
        _workspaceInviteLink = inviteLink;
        return Result.ok(inviteLink);
      case Error():
        return Result.error(result.error);
    }
  }

  Future<Result<ShareResult>> _shareWorkspaceInviteLink() async {
    if (_activeWorkspaceDetails == null) {
      return Result.error(Exception('Active workspace details is empty'));
    }

    if (_workspaceInviteLink == null) {
      return Result.error(Exception('Workspace invite link is empty'));
    }

    final resultShare = await _shareWorkspaceInviteLinkUseCase.share(
      inviteLink: _workspaceInviteLink!,
      workspaceName: _activeWorkspaceDetails!.name,
    );

    switch (resultShare) {
      case Ok():
        return Result.ok(resultShare.value);
      case Error():
        return Result.error(resultShare.error);
    }
  }

  Future<Result<void>> _createVirtualUser(
    (String firstName, String lastName) details,
  ) async {
    final (firstName, lastName) = details;
    final result = await _workspaceUserRepository.createVirtualMember(
      workspaceId: _activeWorkspaceId,
      firstName: firstName,
      lastName: lastName,
    );

    switch (result) {
      case Ok():
        return const Result.ok(null);
      case Error():
        return result;
    }
  }
}
