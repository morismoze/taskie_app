import 'package:flutter/widgets.dart';

import '../../../data/services/api/user/models/response/user_response.dart';
import '../l10n/l10n_extensions.dart';

extension WorkspaceRoleLocalisation on WorkspaceRole {
  String l10n(BuildContext context) {
    switch (this) {
      case WorkspaceRole.manager:
        return context.localization.misc_roleManager;
      case WorkspaceRole.member:
        return context.localization.misc_roleMember;
    }
  }
}
