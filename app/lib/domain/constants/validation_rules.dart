import '../../config/environment/env.dart';
import '../../routing/routes.dart';

abstract final class ValidationRules {
  static const int workspaceNameMinLength = 3;
  static const int workspaceNameMaxLength = 50;
  static const int workspaceDescriptionMaxLength = 250;

  static const int objectiveTitleMinLength = 3;
  static const int objectiveTitleMaxLength = 50;
  static const int objectiveDescriptionMaxLength = 250;
  static const int objectiveMinAssigneesCount = 1;
  static const int taskMaxAssigneesCount = 10;

  static const int workspaceUserNameMinLength = 2;
  static const int workspaceUserNameMaxLength = 50;

  static const int workspaceInviteLinkTokenlength = 24;
  static String get workspaceInviteLinkRegex {
    return '^${RegExp.escape(Env.deepLinkBaseUrl)}/'
        '${Routes.workspacesRelative}/'
        '${Routes.workspaceJoinRelative}/'
        '[a-fA-F0-9]{$workspaceInviteLinkTokenlength}\$';
  }
}
