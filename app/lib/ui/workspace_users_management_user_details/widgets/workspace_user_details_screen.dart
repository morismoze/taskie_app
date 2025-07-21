import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../routing/routes.dart';
import '../../core/l10n/l10n_extensions.dart';
import '../../core/theme/colors.dart';
import '../../core/theme/dimens.dart';
import '../../core/ui/activity_indicator.dart';
import '../../core/ui/app_avatar.dart';
import '../../core/ui/blurred_circles_background.dart';
import '../../core/ui/header_bar/app_header_action_button.dart';
import '../../core/ui/header_bar/header_bar.dart';
import '../../core/ui/role_chip.dart';
import '../view_models/workspace_user_details_screen_view_model.dart';

class WorkspaceUserDetailsScreen extends StatelessWidget {
  const WorkspaceUserDetailsScreen({super.key, required this.viewModel});

  final WorkspaceUserDetailsScreenViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlurredCirclesBackground(
        child: SafeArea(
          child: Column(
            children: [
              HeaderBar(
                title: context.localization.workspaceUsersManagementUserDetails,
                actions: [
                  AppHeaderActionButton(
                    iconData: FontAwesomeIcons.pencil,
                    onTap: () {
                      final workspaceUserId = viewModel.details?.id;

                      if (workspaceUserId != null) {
                        context.push(
                          Routes.workspaceUsersEditUserDetails(
                            workspaceId: viewModel.activeWorkspaceId,
                            workspaceUserId: workspaceUserId,
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
              SingleChildScrollView(
                padding: EdgeInsets.only(
                  top: Dimens.paddingVertical,
                  left: Dimens.of(context).paddingScreenHorizontal,
                  right: Dimens.of(context).paddingScreenHorizontal,
                  bottom: Dimens.paddingVertical,
                ),
                child: ListenableBuilder(
                  listenable: viewModel,
                  builder: (builderContext, _) {
                    final details = viewModel.details;

                    if (details == null) {
                      return ActivityIndicator(
                        radius: 11,
                        color: Theme.of(builderContext).colorScheme.primary,
                      );
                    }

                    final fullName = '${details.firstName} ${details.lastName}';

                    return Column(
                      children: [
                        // First section
                        AppAvatar(
                          text: fullName,
                          imageUrl: details.profileImageUrl,
                          radius: 50,
                        ),
                        const SizedBox(height: 30),
                        // Second section
                        RoleChip(role: details.role),
                        const SizedBox(height: 5),
                        Text(
                          fullName,
                          style: Theme.of(context).textTheme.headlineMedium,
                        ),
                        if (details.email != null) ...[
                          const SizedBox(height: 5),
                          Text(
                            details.email!,
                            style: Theme.of(context).textTheme.titleMedium!
                                .copyWith(color: AppColors.grey2),
                          ),
                        ],
                        const SizedBox(height: 30),
                        // Third section
                        _LabeledData(
                          label: context.localization.createdAt,
                          data: DateFormat.yMd(
                            Localizations.localeOf(context).toString(),
                          ).format(details.createdAt),
                        ),
                        if (details.createdBy != null) ...[
                          const SizedBox(height: 15),
                          _LabeledData(
                            label: context.localization.createdBy,
                            leading: AppAvatar(
                              text: fullName,
                              imageUrl: details.createdBy!.profileImageUrl,
                            ),
                            data:
                                '${details.createdBy!.firstName} ${details.createdBy!.lastName}',
                          ),
                        ],
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LabeledData extends StatelessWidget {
  const _LabeledData({
    super.key,
    required this.label,
    required this.data,
    this.leading,
  });

  final String label;
  final String data;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 8,
      children: [
        Text(
          '$label: ',
          style: Theme.of(
            context,
          ).textTheme.bodyMedium!.copyWith(fontWeight: FontWeight.bold),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (leading != null) ...[leading!, const SizedBox(width: 8)],
            Text(
              data,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.normal),
            ),
          ],
        ),
      ],
    );
  }
}
