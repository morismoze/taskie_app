import 'package:flutter/foundation.dart';

import '../../../domain/use_cases/create_workspace_use_case.dart';
import '../../../domain/use_cases/join_workspace_use_case.dart';
import '../../../routing/routes.dart';
import '../../../utils/command.dart';

class CreateWorkspaceScreenViewModel extends ChangeNotifier {
  CreateWorkspaceScreenViewModel({
    required CreateWorkspaceUseCase createWorkspaceUseCase,
    required JoinWorkspaceUseCase joinWorkspaceUseCase,
  }) : _createWorkspaceUseCase = createWorkspaceUseCase,
       _joinWorkspaceUseCase = joinWorkspaceUseCase {
    createWorkspace = Command1(_createWorkspace);
    joinWorkspaceViaInviteLink = Command1(_joinWorkspaceViaInviteLink);
  }

  final CreateWorkspaceUseCase _createWorkspaceUseCase;
  final JoinWorkspaceUseCase _joinWorkspaceUseCase;

  /// Returns ID of the newly created workspace
  late Command1<String, (String name, String? description)> createWorkspace;
  late Command1<String, String> joinWorkspaceViaInviteLink;

  Future<Result<String>> _createWorkspace(
    (String name, String? description) details,
  ) async {
    final (name, description) = details;
    final resultCreate = await _createWorkspaceUseCase.createWorkspace(
      name: name,
      description: description,
    );

    return resultCreate;
  }

  Future<Result<String>> _joinWorkspaceViaInviteLink(String inviteLink) async {
    try {
      final inviteToken = inviteLink.split(
        '${Routes.workspaceJoinRelative}/',
      )[1];

      // This case should never happen because of the specific
      // validation of the invite link field.
      if (inviteToken.isEmpty) {
        return Result.error(Exception('Invalid invite link'));
      }

      return await _joinWorkspaceUseCase.joinWorkspace(inviteToken);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
