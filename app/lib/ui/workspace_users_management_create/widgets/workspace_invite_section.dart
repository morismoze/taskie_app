import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/l10n/l10n_extensions.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_text_button.dart';
import '../../core/ui/app_text_field/app_text_field.dart';
import '../view_models/create_workspace_user_screen_view_model.dart';
import 'workspace_invite_action_button.dart';

class WorkspaceInviteSection extends StatelessWidget {
  const WorkspaceInviteSection({
    super.key,
    required this.viewModel,
    required this.controller,
  });

  final CreateWorkspaceUserScreenViewModel viewModel;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      spacing: 30,
      children: [
        Text(
          context
              .localization
              .workspaceUsersManagementCreateWorkspaceInviteDescription,
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        ListenableBuilder(
          listenable: Listenable.merge([
            controller,
            viewModel.createWorkspaceInviteLink,
          ]),
          builder: (context, child) {
            if (viewModel.createWorkspaceInviteLink.error) {
              return Text.rich(
                textAlign: TextAlign.center,
                TextSpan(
                  text:
                      '${context.localization.workspaceUsersManagementCreateWorkspaceInviteError} ',
                  style: Theme.of(context).textTheme.labelMedium!.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.normal,
                  ),
                  children: [
                    WidgetSpan(
                      alignment: PlaceholderAlignment.baseline,
                      baseline: TextBaseline.alphabetic,
                      child: AppTextButton(
                        underline: true,
                        onPress: () =>
                            viewModel.createWorkspaceInviteLink.execute(true),
                        label: context.localization.misc_tryAgain,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        shrinkWrap: true,
                      ),
                    ),
                  ],
                ),
              );
            }

            if (viewModel.createWorkspaceInviteLink.running ||
                controller.text.isEmpty) {
              return const ActivityIndicator(radius: 11);
            }

            return Column(
              children: [
                Row(
                  spacing: 10,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  // `baseline` "centers" the Row children by
                  // the plane they are "sitting" on.
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  // This is neeeded when `baseline` alignment is used
                  textBaseline: TextBaseline.alphabetic,
                  children: [
                    Expanded(
                      child: AppTextField(
                        controller: controller,
                        readOnly: true,
                        label: context.localization.workspaceInviteLabel,
                      ),
                    ),
                    WorkspaceInviteActionButton(
                      onTap: () => viewModel.shareWorkspaceInviteLink.execute(),
                      iconData: FontAwesomeIcons.share,
                    ),
                    WorkspaceInviteActionButton(
                      onTap: () async {
                        await Clipboard.setData(
                          ClipboardData(text: controller.text),
                        );
                        viewModel.createWorkspaceInviteLink.execute(true);
                      },
                      iconData: FontAwesomeIcons.clipboard,
                    ),
                  ],
                ),
                Text.rich(
                  TextSpan(
                    text: '${context.localization.misc_note}: ',
                    style: Theme.of(context).textTheme.labelMedium!.copyWith(
                      fontSize: 13,
                      fontStyle: FontStyle.italic,
                      fontWeight: FontWeight.bold,
                    ),
                    children: [
                      TextSpan(
                        text: context
                            .localization
                            .workspaceUsersManagementCreateWorkspaceInviteNote,
                        style: Theme.of(context).textTheme.labelMedium!
                            .copyWith(
                              fontSize: 13,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.normal,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
