import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/ui/app_modal.dart';
import '../../core/ui/app_modal_bottom_sheet.dart';
import '../../core/ui/app_text_button.dart';
import 'app_drawer_viewmodel.dart';
import 'workspace_image.dart';

class WorkspaceTile extends StatefulWidget {
  const WorkspaceTile({
    super.key,
    required this.id,
    required this.name,
    required this.viewModel,
    this.pictureUrl,
  });

  final String id;
  final String name;
  final AppDrawerViewModel viewModel;
  final String? pictureUrl;

  @override
  State<WorkspaceTile> createState() => _WorkspaceTileState();
}

class _WorkspaceTileState extends State<WorkspaceTile> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.all(0),
      leading: WorkspaceImage(url: widget.pictureUrl),
      trailing: InkWell(
        splashFactory: NoSplash.splashFactory,
        onTap: () => _onWorkspaceOptionsTap(context, widget.id),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
          child: FaIcon(
            FontAwesomeIcons.ellipsisVertical,
            color: AppColors.grey2,
            size: 20,
          ),
        ),
      ),
      title: Text(
        widget.name,
        style: Theme.of(
          context,
        ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }

  void _onWorkspaceOptionsTap(BuildContext context, String workspaceId) {
    AppModalBottomSheet.show(
      context: context,
      enableDrag: !widget.viewModel.leaveWorkspace.running,
      isDismissable: !widget.viewModel.leaveWorkspace.running,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              WorkspaceImage(url: widget.pictureUrl, size: 50),
              const SizedBox(width: 12),
              Text(
                widget.name,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTextButton(
            onPress: () => context.push(Routes.workspaceInvite(widget.id)),
            label: context.localization.appDrawerInviteMembers,
            leadingIcon: FontAwesomeIcons.userPlus,
          ),
          ListenableBuilder(
            listenable: widget.viewModel.leaveWorkspace,
            builder: (context, _) => AppTextButton(
              onPress: () => _confirmWorkspaceLeave(context, workspaceId),
              label: context.localization.appDrawerLeaveWorkspace,
              leadingIcon: FontAwesomeIcons.arrowRightFromBracket,
              color: Theme.of(context).colorScheme.error,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmWorkspaceLeave(BuildContext context, String workspaceId) {
    AppModal.show(
      context: context,
      title: FaIcon(
        FontAwesomeIcons.circleExclamation,
        color: Theme.of(context).colorScheme.error,
        size: 30,
      ),
      message: Text(
        context.localization.appDrawerLeaveWorkspaceModalMessage,
        style: Theme.of(context).textTheme.bodyMedium,
        textAlign: TextAlign.center,
      ),
      ctaButton: CtaButton(
        label: context.localization.appDrawerLeaveWorkspaceModalCta,
        onPress: () => widget.viewModel.leaveWorkspace.execute(workspaceId),
        isLoading: widget.viewModel.leaveWorkspace.running,
        type: CtaType.error,
      ),
      cancelButton: CancelButton(
        label: context.localization.cancel,
        onPress: () => Navigator.pop(context),
      ),
    );
  }
}
