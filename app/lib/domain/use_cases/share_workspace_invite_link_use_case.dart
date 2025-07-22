import 'package:share_plus/share_plus.dart';

import '../../utils/command.dart';

class ShareWorkspaceInviteLinkUseCase {
  Future<Result<ShareResult>> share({
    required String workspaceName,
    required String inviteLink,
  }) async {
    final text =
        'You are invited to join my workspace *$workspaceName*. Use this link to get started:\n\n'
        '$inviteLink';

    try {
      final result = await SharePlus.instance.share(ShareParams(text: text));
      return Result.ok(result);
    } on Exception catch (e) {
      return Result.error(e);
    }
  }
}
